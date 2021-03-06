class window.App.ContractLineAssignItemController extends Spine.Controller

  events:
    "focus [data-assign-item]": "searchItems"
    "submit [data-assign-item-form]": "submitAssignment"
    "click [data-remove-assignment]": "removeAssignment"

  constructor: ->
    super

  searchItems: (e)=>
    target = $ e.currentTarget
    model = App.ContractLine.find(target.closest("[data-id]").data("id")).model()
    @fetchItems(model).done (data)=> 
      items = (App.Item.find(datum.id) for datum in data) 
      if items.length
        location_ids = _.compact _.uniq _.map items, (i)->i.location_id
        @fetchLocations(location_ids).done (data)=>
          if data?
            locations = (App.Location.find(datum.id) for datum in data)
            building_ids = _.compact _.uniq _.map locations, (l)-> l.building_id
            @fetchBuildings(building_ids).done => @setupAutocomplete(target, items)

  setupAutocomplete: (input, items)->
    return false if not input.is(":focus") or input.is(":disabled")
    input.autocomplete
      appendTo: input.closest(".line")
      source: (request, response)=> 
        data = _.map items, (u)=>
          u.value = u.id
          u
        data = _.filter data, (i)->i.inventory_code.match request.term
        response data
      focus: => return false
      minLength: 0
      select: (e, ui)=> @assignItem(input, ui.item); return false
    .data("uiAutocomplete")._renderItem = (ul, item) => 
      $(App.Render "manage/views/items/autocomplete_element", item).data("value", item).appendTo(ul)
    input.autocomplete("search", "")

  fetchItems: (model)=>
    App.Item.ajaxFetch
      data: $.param 
        model_ids: [model.id]
        in_stock: true
        responsible_or_owner_as_fallback: true

  fetchLocations: (ids)=>
    return {done: (c)-> c()} unless ids.length
    App.Location.ajaxFetch
      data: $.param 
        ids: ids

  fetchBuildings: (ids)=>
    return {done: (c)-> c()} unless ids.length
    App.Building.ajaxFetch
      data: $.param 
        ids: ids

  assignItem: (input, item)=>
    input.blur()
    input.autocomplete "destroy"
    contractLine = App.ContractLine.find input.closest("[data-id]").data("id")
    contractLine.assign item, =>
      input.val item.inventory_code
      input.attr "disabled", true
      App.LineSelectionController.add contractLine.id

  removeAssignment: (e)=>
    target = $ e.currentTarget
    contractLine = App.ContractLine.find target.closest("[data-id]").data("id")
    do contractLine.removeAssignment
    App.Flash
      type: "notice"
      message: _jed "The assignment for %s was removed", contractLine.model().name

  submitAssignment: (e)=>
    e.preventDefault()
    target = $(e.currentTarget).find("[data-assign-item]")
    contractLine = App.ContractLine.find target.closest("[data-id]").data("id")
    inventoryCode = target.val()
    App.Item.ajaxFetch
      data: $.param
        inventory_code: inventoryCode
        model_ids: [contractLine.model().id]
    .done (data)=>
      if data.length == 1
        @assignItem target, App.Item.find(data[0].id)
      else
        App.Flash
          type: "error"
          message: _jed "The Inventory Code %s was not found for %s", [inventoryCode, contractLine.model().name]
