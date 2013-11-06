# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
#nested forms without link_to_function (which has been deprecated)
  add_fields = (event) ->
    #clone fields
    last_fieldset = $('fieldset.nested_fields').last()
    new_fieldset = last_fieldset.clone(true, true)
    count_nested_fieldsets = $('fieldset.nested_fields').length
    #modify elements of cloned fieldset
    new_fieldset.children().each ->
      element = $(this)

      element.val('')
      if element.attr('for')
        old_for = element.attr('for')
        new_for = old_for.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        element.attr('for', new_for)
      if element.attr('id')
        old_id = element.attr('id')
        new_id = old_id.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        element.attr('id', new_id)
      if element.attr('name')
        old_name = element.attr('name')
        new_name = old_name.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        element.attr('name', new_name)
    
    #required for icon to work
    last_icon_id = last_fieldset.find('.icon').attr('id')
    last_icon_id_number = parseInt(last_icon_id.slice(4))
    new_id = last_icon_id.replace(new RegExp(/[0-9]+/), "#{last_icon_id_number + 1}")
    new_fieldset.children('.icon').attr('id', new_id)

    new_fieldset.insertBefore($('.add_fields'))
    $('<a class="btn btn-default remove_fields" href="">remove panel</a><br />').insertBefore($(event.target))

  remove_fields = (event) ->
    $(event.target).prev('.nested_fields').remove()
    $(event.target).remove()
    

  $(document).on 'click', '.add_fields', (event) ->
    event.preventDefault()
    add_fields(event)

  $(document).on 'click', '.remove_fields', (event) ->
    event.preventDefault()
    remove_fields(event)
