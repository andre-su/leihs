class window.App.InventoryIndexController extends Spine.Controller

  elements:
    "#inventory": "list"
    "#list-filters #responsibles": "responsiblesContainer"
    "#csv-export": "exportButton"
    "#csv-export": "exportButton"
    "#categories": "categoriesContainer"

  events: 
    "click #categories-toggle": "toggleCategories"

  constructor: ->
    super
    @pagination = new App.ListPaginationController {el: @list, fetch: @fetch}
    @search = new App.ListSearchController {el: @el.find("#list-search"), reset: @reset}
    @tabs = new App.ListTabsController {el: @el.find("#list-tabs"), reset: @reset}
    @filter = new App.ListFiltersController {el: @el.find("#list-filters"), reset: @reset}
    new App.TimeLineController {el: @el}
    new App.InventoryExpandController {el: @el}
    @fetchResponsibles().done @renderResponsibles
    @exportButton.data "href", @exportButton.attr("href")
    do @reset

  reset: =>
    @inventory = {}
    App.Inventory.deleteAll()
    App.Item.deleteAll()
    App.Model.deleteAll()
    App.Option.deleteAll()
    do @updateExportButton
    @list.html App.Render "manage/views/lists/loading"
    @fetch 1, @list

  updateExportButton: =>
    data = @getData()
    data.search_term = @search.term() if @search.term()?.length
    @exportButton.attr "href", URI(@exportButton.data("href")).query(data).toString()

  fetch: (page, target)=>
    @fetchInventory(page).done =>
      @fetchAvailability(page).done =>
        @fetchItems(page).done =>
          @render target, @inventory[page], page

  fetchInventory: (page)=>
    App.Inventory.ajaxFetch
      data: $.param $.extend @getData(),
        page: page
        search_term: @search.term()
        category_id: @categoriesFilter?.getCurrent()?.id
        unretired: true
        sort: "name"
        order: "ASC"
    .done (data, status, xhr) => 
      @pagination.set JSON.parse(xhr.getResponseHeader("X-Pagination"))
      inventory = (App.Inventory.find(datum.id).cast() for datum in data)
      @inventory[page] = inventory

  fetchAvailability: (page)=>
    models = _.filter @inventory[page], (i)-> i.constructor.className == "Model"
    ids = _.map models, (m)-> m.id
    return {done: (c)->c()} unless ids.length
    App.Availability.ajaxFetch
      url: App.Availability.url()+"/in_stock"
      data: $.param
        model_ids: ids

  fetchItems: (page)=>
    models = _.filter @inventory[page], (i)-> i.constructor.className == "Model"
    ids = _.map models, (m)-> m.id
    return {done: (c)->c()} unless ids.length
    App.Item.ajaxFetch
      data: $.param $.extend @getData(),
        model_ids: ids
        paginate: false
        search_term: @search.term()
        all: true
        unretired: true

  getData: => _.clone $.extend @tabs.getData(), @filter.getData()

  fetchResponsibles: =>
    App.Inventory.fetchResponsibles @getData()

  renderResponsibles: (data)=>
    for datum in data
      @responsiblesContainer.append App.Render "manage/views/inventory/responsible", datum

  render: (target, data, page)=> 
    if data?
      if data.length
        target.html App.Render "manage/views/inventory/line", data
        @pagination.renderPlaceholders() if page == 1
      else
        target.html App.Render "manage/views/lists/no_results"

  toggleCategories: =>
    @categoriesFilter = new App.CategoriesFilterController({el: @categoriesContainer, filter: @reset}) unless @categoriesFilter?
    if @categoriesContainer.hasClass "hidden"
      do @openCategories
    else 
      do @closeCategories

  openCategories: =>
    @list.addClass "col4of5"
    @categoriesContainer.addClass("col1of5").removeClass("hidden")

  closeCategories: =>
    @list.removeClass "col4of5"
    @categoriesContainer.removeClass("col1of5").addClass("hidden")
