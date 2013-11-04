# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#creates link to remove form field. Requires accepts_nested_attributes_for association. See railscast #197
jQuery ->
  #window.remove_fields = (link) -> 
    #$(link).prev("input[type=hidden]").val("1")
    #$(link).closest('.nested_fields').hide()

#add fields. See railscast #197
#  window.add_fields = (link, association, content) ->
#   new_id = new Date().getTime()
#   regexp = new RegExp("new_" + association, "g")
#   $(link).before(content.replace(regexp, new_id))
#   $('input.dob').datepicker({
#     minDate: null,
#     yearRange: 'c-100:c'
#   });
#nested forms without link_to_function (which has been deprecated)
  add_fields = (event) ->
    #clone fields
    last_fieldset = $('fieldset.nested_fields').last()
    new_fieldset = last_fieldset.clone()
    count_nested_fieldsets = $('fieldset.nested_fields').length
    #modify ids
    new_fieldset.children().each ->
      element = $(this)

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
      #required for icon to work. This must go at end of each loop (so it does
      #not get overwritten by above code)
      if $(this).is('#icon1')
        last_icon_id_number = parseInt(last_fieldset.children('.icon').attr('id').slice(4))
        old_id = element.attr('id')
        new_id = old_id.replace(new RegExp(/[0-9]+/), "#{last_icon_id_number + 1}")
        element.attr('id', new_id)
    new_fieldset.insertBefore($('.add_fields'))
    $('<a class="remove_fields" href="">Remove panel</a>').insertBefore($(event.target))

  remove_fields = () ->
    alert 'hello'
    #$(this).closest('.nested_fields').css('border', '1px solid red')

  $(document).on 'click', '.add_fields', (event) ->
    add_fields(event)

  $(document).on 'click', '.remove_fields', (event) ->
    #add_fields(event)
    remove_fields()
