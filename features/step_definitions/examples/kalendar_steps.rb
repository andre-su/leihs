# encoding: utf-8

Wenn /^man den Kalender sieht$/ do
  step 'I open a contract for acknowledgement'
  @line_element = first(".line")
  step 'I open the booking calendar for this line'
end

Dann /^sehe ich die Verfügbarkeit von Modellen auch an Feier\- und Ferientagen sowie Wochenenden$/ do
  while all(".fc-widget-content.holiday").empty? do
    first(".fc-button-next").click
  end
  first(".fc-widget-content.holiday .fc-day-content div").text.should_not == ""
  first(".fc-widget-content.holiday .fc-day-content div").text.to_i >= 0
  first(".fc-widget-content.holiday .fc-day-content .total_quantity").text.should_not == ""
end

Angenommen /^ich öffne den Kalender$/ do
  @line_el = find(".line", match: :first)
  id = @line_el["data-id"] || JSON.parse(@line_el["data-ids"]).first
  @line = ContractLine.find_by_id id
  @line_el.find(".multibutton .button[data-edit-lines]", :text => _("Change entry")).click
  find(".fc-day-content", match: :first)
end

Dann /^kann ich die Anzahl unbegrenzt erhöhen \/ überbuchen$/ do
  @size = @line.model.items.where(:inventory_pool_id => @ip).size*2
  find(".modal #booking-calendar-quantity").set @size
  find(".modal #booking-calendar-quantity").value.to_i.should == @size
end

Dann /^die Bestellung kann gespeichert werden$/ do
  step 'I save the booking calendar'
  @line.contract.lines.where(:start_date => @line.start_date, :end_date => @line.end_date, :model_id => @line.model).size == @size
end

Dann /^die Aushändigung kann gespeichert werden$/ do
  step 'I save the booking calendar'
  @line.contract.lines.where(:model_id => @line.model).size.should >= @size
end

Angenommen /^ich editiere alle Linien$/ do
  find(".multibutton .green.dropdown-toggle").click
  find(".multibutton .dropdown-item[data-edit-lines='selected-lines']", :text => _("Edit Selection")).click
end

Dann /^wird in der Liste unter dem Kalender die entsprechende Linie als nicht verfügbar \(rot\) ausgezeichnet$/ do
  find(".modal .line-info.red ~ .col5of10", match: :prefer_exact, :text => @model.name)
end
