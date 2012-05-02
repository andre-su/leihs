When /^I open an order for acknowledgement$/ do
  @ip = @user.managed_inventory_pools.first
  @customer = @ip.users.all.detect {|x| x.orders.submitted.count > 0}
  @order = @customer.orders.submitted.first
  visit backend_inventory_pool_acknowledge_path(@ip, @order)
  page.has_css?("#acknowledge", :visible => true)
end

When /^I open an order for acknowledgement with more then one line$/ do
  @ip = @user.managed_inventory_pools.first
  @customer = @ip.users.all.detect {|x| x.orders.submitted.count > 0 and x.orders.submitted.first.lines.size > 1}
  @order = @customer.orders.submitted.first
  visit backend_inventory_pool_acknowledge_path(@ip, @order)
  page.has_css?("#acknowledge", :visible => true)
end

When /^I open the booking calendar for this line$/ do
  @line_element.find(".button", :text => "Edit").click
  wait_until { find("#fullcalendar .fc-day-content") }
end

When /^I edit the timerange of the selection$/ do
  page.execute_script('$("#selection_actions .button").show()')
  find(".button", :text => "Edit Selection").click
  wait_until { find("#fullcalendar .fc-day-content") }
end

When /^I save the booking calendar$/ do
  find(".dialog .button", :text => "Save Changes").click
  wait_until { all(".dialog").size == 0 }
end

When /^I change (.*?) lines time range$/ do |type|
  @line = case type
  when "an order"
    @order.lines.first
  when "a contract"
    @customer.visits.hand_over.first.lines.first
  end
  @line_element = find(".line", :text => @line.model.name)
  step 'I open the booking calendar for this line'
  @new_start_date = @line.start_date + 1.day
  wait_until { find(".fc-widget-content .fc-day-number") }
  @new_start_date_element = if @new_start_date.month > @line.start_date.month or @new_start_date.year > @line.start_date.year 
    all(".fc-widget-content.fc-other-month .fc-day-number", :text => /^#{@new_start_date.day}$/).last 
  else
    all(".fc-widget-content:not(.fc-other-month) .fc-day-number", :text => /^#{@new_start_date.day}$/).last
  end
  @new_start_date_element.click
  find("a", :text => "Start Date").click
  step 'I save the booking calendar'
end

Then /^the time range of that line is changed$/ do
  @line.reload.start_date.should == @new_start_date
end

When /^I change (.*?) lines quantity$/ do |type|
  @line = case type
  when "an order"
    @order.lines.first
  when "a contract"
    @customer.visits.hand_over.first.lines.first
  end
  @line_element = find(".line", :text => @line.model.name)
  step 'I open the booking calendar for this line'
  @new_quantity = @line.model.items.size
  find(".dialog input#quantity").set @new_quantity
  step 'I save the booking calendar'
end

Then /^the quantity of that line is changed$/ do
  @line_element = find(".line", :text => @line.model.name)
  @line_element.find(".amount .selected").text.should == @new_quantity.to_s
end

When /^I change the time range for multiple lines$/ do
  @line1 = @order.lines.first
  @line1_element = find(".line", :text => @line1.model.name)
  @line1_element.find("input[type=checkbox]").click
  @line2 = @order.lines.second
  @line2_element = find(".line", :text => @line2.model.name)
  @line2_element.find("input[type=checkbox]").click
  step 'I edit the timerange of the selection'
  @new_start_date = @line1.start_date + 2.days
  @new_start_date_element = if @new_start_date.month > @line1.start_date.month or @new_start_date.year > @line1.start_date.year 
    all(".fc-widget-content.fc-other-month .fc-day-number", :text => /^#{@new_start_date.day}$/).last
  else
    all(".fc-widget-content:not(.fc-other-month) .fc-day-number", :text => /^#{@new_start_date.day}$/).last
  end
  @new_start_date_element.click
  find("a", :text => "Start Date").click
  step 'I save the booking calendar'
end

Then /^the time range for that lines is changed$/ do
  @line1.reload.start_date.should == @line2.reload.start_date 
  @line1.reload.start_date.should == @new_start_date
end