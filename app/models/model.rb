# A Model is a type of a thing which is available inside
# an #InventoryPool for borrowing. If a customer wants to
# borrow a thing, he opens an #Order and chooses the
# appropriate Model. The #InventoryPool manager then hands
# him over an instance - an #Item - of that Model, in case
# one is still available for borrowing.
#
# The description of the #Item class contains an example.
#
#
class Model < ActiveRecord::Base
  include Availability::Model

  before_destroy do
    if is_package? and contract_lines.empty?
      items.destroy_all
    end
  end

  has_many :items, dependent: :restrict # NOTE these are only the active items (unretired), because Item has a default_scope
  accepts_nested_attributes_for :items, :allow_destroy => true

  has_many :unretired_items, :class_name => "Item", :conditions => {:retired => nil} # TODO this is used by the filter
  #TODO  do we need a :all_items ??
  has_many :borrowable_items, :class_name => "Item", :conditions => {:retired => nil, :is_borrowable => true, :parent_id => nil}
  has_many :unborrowable_items, :class_name => "Item", :conditions => {:retired => nil, :is_borrowable => false}
  has_many :unpackaged_items, :class_name => "Item", :conditions => {:parent_id => nil}
  
  has_many :locations, :through => :items, :uniq => true  # OPTIMIZE N+1 select problem, :include => :inventory_pools
  has_many :inventory_pools, :through => :items, :uniq => true

  has_many :partitions, :dependent => :delete_all do
    def set_in(inventory_pool, new_partitions)
      where(:inventory_pool_id => inventory_pool).scoping do
        delete_all
        new_partitions.delete(Group::GENERAL_GROUP_ID)
        unless new_partitions.blank?
          valid_group_ids = inventory_pool.group_ids
          new_partitions.each_pair do |group_id, quantity|
            group_id = group_id.to_i
            quantity = quantity.to_i
            create(:group_id => group_id, :quantity => quantity) if valid_group_ids.include?(group_id) and quantity > 0
          end
        end
        # if there's no more items of a model in a group accessible to the customer, then he shouldn't be able to see the model in the frontend.
      end
    end
  end
  accepts_nested_attributes_for :partitions, :allow_destroy => true
  # MySQL View based on partitions and items
  has_many :partitions_with_generals

  has_many :contract_lines, dependent: :restrict
  has_many :properties, :dependent => :destroy
  accepts_nested_attributes_for :properties, :allow_destroy => true

  has_many :accessories, :dependent => :destroy
  accepts_nested_attributes_for :accessories, :allow_destroy => true

  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, :allow_destroy => true

  # ModelGroups
  has_many :model_links, :dependent => :destroy
  has_many :model_groups, :through => :model_links, :uniq => true
  has_many :categories, :through => :model_links, :source => :model_group, :conditions => {:type => 'Category'}
  has_many :templates, :through => :model_links, :source => :model_group, :conditions => {:type => 'Template'}

########
  # says which other Model one Model works with
  has_and_belongs_to_many :compatibles,
                          :class_name => "Model",
                          :join_table => "models_compatibles",
                          :foreign_key => "model_id",
                          :association_foreign_key => "compatible_id",
                          :uniq => true

#############################################  

  validates_presence_of :name
  validates_uniqueness_of :name

#############################################

  # OPTIMIZE Mysql::Error: Not unique table/alias: 'items'
  scope :active, select("DISTINCT models.*").joins(:items).where("items.retired IS NULL")

  scope :without_items, select("models.*").joins("LEFT JOIN items ON items.model_id = models.id").
                        where(['items.model_id IS NULL'])

  scope :unused_for_inventory_pool, ( lambda do |ip|
    model_ids = Model.select("models.id").joins(:items).where(":id IN (items.owner_id, items.inventory_pool_id)", :id => ip.id).uniq
    Model.where("models.id NOT IN (#{model_ids.to_sql})")
  end )

  scope :packages, where(:is_package => true)

  scope :with_properties, select("DISTINCT models.*").
                          joins("LEFT JOIN properties ON properties.model_id = models.id").
                          where("properties.model_id IS NOT NULL")

  scope :by_inventory_pool, lambda { |inventory_pool| select("DISTINCT models.*").joins(:items).
                                                      where(["items.inventory_pool_id = ?", inventory_pool]) }

  scope :all_from_inventory_pools, lambda { |inventory_pool_ids| joins(:items).where("items.inventory_pool_id IN (?)", inventory_pool_ids) }

  scope :by_categories, lambda { |categories| joins("INNER JOIN model_links AS ml"). # OPTIMIZE no ON ??
                                              where(["ml.model_group_id IN (?)", categories]) }

  scope :from_category_and_all_its_descendants, lambda { |category_id|
    joins(:categories).where(:"model_groups.id" => [Category.find(category_id)] + Category.find(category_id).descendants) }

  scope :order_by_attribute_and_direction, (lambda do |attr, direction|
    if ["name", "manufacturer"].include? attr and ["asc", "desc"].include? direction
      order "#{attr} #{direction.upcase}"
    else
      default_order
    end
  end)

  scope :default_order, order_by_attribute_and_direction("name", "asc")


#############################################

  SEARCHABLE_FIELDS = %w(name manufacturer)

  scope :search, lambda { |query , fields = []|
    return scoped if query.blank?

    sql = select("DISTINCT models.*") #old# joins(:categories, :properties, :items)
    if fields.empty?
      sql = sql.
        joins("LEFT JOIN `model_links` AS ml2 ON `ml2`.`model_id` = `models`.`id`").
        joins("LEFT JOIN `model_groups` AS mg2 ON `mg2`.`id` = `ml2`.`model_group_id` AND `mg2`.`type` = 'Category'").
        joins("LEFT JOIN `properties` AS p2 ON `p2`.`model_id` = `models`.`id`")
    end
    sql = sql.joins("LEFT JOIN `items` AS i2 ON `i2`.`model_id` = `models`.`id`") if fields.empty? or fields.include?(:items)

    # FIXME refactor to Arel
    query.split.each do |x|
      s = []
      s1 = ["' '"]
      s1 << "models.name" if fields.empty? or fields.include?(:name)
      s1 << "models.manufacturer" if fields.empty? or fields.include?(:manufacturer)
      s << "CONCAT_WS(#{s1.join(', ')}) LIKE :query"
      if fields.empty?
        s << "mg2.name LIKE :query"
        s << "p2.value LIKE :query"
      end
      s << "CONCAT_WS(' ', i2.inventory_code, i2.serial_number, i2.invoice_number, i2.note, i2.name, i2.user_name, i2.properties) LIKE :query" if fields.empty? or fields.include?(:items)
      
      sql = sql.where("%s" % s.join(' OR '), :query => "%#{x}%")
    end
    sql
  }

  def self.filter(params, subject = nil, category = nil, borrowable = false)
    models = if subject.is_a? User
               filter_for_user params, subject, category, borrowable
             elsif subject.is_a? InventoryPool
               filter_for_inventory_pool params, subject, category
             else
               scoped
             end
    models = models.where(id: params[:id]) if params[:id]
    models = models.where(id: params[:ids]) if params[:ids]
    models = models.joins(:items).where(:items => {:is_borrowable => true}) if borrowable or params[:borrowable]
    models = models.search(params[:search_term], params[:search_targets] ? params[:search_targets] : [:name, :manufacturer]) unless params[:search_term].blank?
    models = models.order_by_attribute_and_direction params[:sort], params[:order]
    models = models.paginate(:page => params[:page]||1, :per_page => [(params[:per_page].try(&:to_i) || 20), 100].min) unless params[:paginate] == "false"
    models
  end

  def self.filter_for_user(params, user, category, borrowable = false)
    models = if category then user.models.from_category_and_all_its_descendants(category.id).borrowable else user.models.borrowable end
    models = models.all_from_inventory_pools(user.inventory_pools.where(id: params[:inventory_pool_ids]).map(&:id)) unless params[:inventory_pool_ids].blank?
    models
  end

  def self.filter_for_inventory_pool(params, inventory_pool, category)
    if params[:all]
      models = scoped
    elsif params[:unused_models]
      models = unused_for_inventory_pool inventory_pool
    else
      models = joins(:items).where(":id IN (`items`.`owner_id`, `items`.`inventory_pool_id`)", :id => inventory_pool.id).uniq
      models = models.joins(:items).where(:items => {:retired => nil}) unless params[:include_retired_models]
      models = models.joins(:items).where(:items => {:parent_id => nil}) unless params[:include_package_models]
    end

    unless params[:unused_models]
      models = models.joins(:items).where(items: {id: params[:item_ids]}) if params[:item_ids]
      models = models.joins(:items).where(:items => {:inventory_pool_id => params[:responsible_id]}) if params[:responsible_id]
    end

    models = models.joins(:categories).where(:"model_groups.id" => [Category.find(params[:category_id])] + Category.find(params[:category_id]).descendants) unless params[:category_id].blank?
    models = models.joins(:model_links).where(:model_links => {:model_group_id => params[:template_id]}) if params[:template_id]
    models
  end


#############################################  

  def to_s
    "#{name}"
  end

  # compares two objects in order to sort them
  def <=>(other)
    self.name <=> other.name
  end

  # TODO 06** define main image
  def image_thumb(offset = 0)
    image(offset, :thumb)
  end
  
  def image(offset = 0, size = nil)
    images.limit(1).offset(offset).first.try(:public_filename, size)
  end

  def lines
    contract_lines
  end
  
  def needs_permission
    items.each do |item|
      return true if item.needs_permission
    end
    return false
  end

#############################################  

  # returns an array of contract_lines
  def add_to_contract(contract, user_id, quantity = nil, start_date = nil, end_date = nil)
    contract.add_lines(quantity, self, user_id, start_date, end_date)
  end

#############################################

  def total_borrowable_items_for_user(user, inventory_pool = nil)
    groups = user.groups.with_general
    if inventory_pool
      inventory_pool.partitions_with_generals.hash_for_model_and_groups(self, groups).values.sum
      #tmp# inventory_pool.partitions_with_generals.where(model_id: id, group_id: groups).sum(:quantity)
    else
      inventory_pools.sum {|ip| ip.partitions_with_generals.hash_for_model_and_groups(self, groups).values.sum }
    end
  end

end

