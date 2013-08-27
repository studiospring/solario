# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#creates link to remove form field. Requires accepts_nested_attributes_for association. See railscast #197
jQuery ->
  window.remove_fields = (link) -> 
    $(link).prev("input[type=hidden]").val("1")
    $(link).closest('.nested_fields').hide()

#nested forms without link_to_function (which has been deprecated)
  add_fields = () ->
    #clone fields
    old_fieldset = $('fieldset.nested_fields').last()
    new_fieldset = old_fieldset.clone()
    count_nested_fieldsets = $('fieldset.nested_fields').length
    #modify input ids
    new_fieldset.children().each ->
      if $(this).attr('for')
        old_for = $(this).attr('for')
        new_for = old_for.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        $(this).attr('for', new_for)
      if $(this).attr('id')
        old_id = $(this).attr('id')
        new_id = old_id.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        $(this).attr('id', new_id)
      if $(this).attr('name')
        old_name = $(this).attr('name')
        new_name = old_name.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        $(this).attr('name', new_name)
    new_fieldset.insertBefore($('.add_fields'))

  $('.add_fields').click (e) ->
    e.preventDefault()
    add_fields()
