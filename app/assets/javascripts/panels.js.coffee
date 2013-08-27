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
    old_fieldset = $('fieldset.nested_fields').last()
    new_fieldset = old_fieldset.clone()
    count_nested_fieldsets = $('fieldset.nested_fields').length
    #modify input ids
    new_fieldset.children().each ->
      form_tag = $(this)
      if form_tag.attr('for')
        old_for = form_tag.attr('for')
        new_for = old_for.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        form_tag.attr('for', new_for)
      if form_tag.attr('id')
        old_id = form_tag.attr('id')
        new_id = old_id.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        form_tag.attr('id', new_id)
      if form_tag.attr('name')
        old_name = form_tag.attr('name')
        new_name = old_name.replace(new RegExp(/[0-9]+/), "#{count_nested_fieldsets}")
        form_tag.attr('name', new_name)
    new_fieldset.insertBefore($('.add_fields'))
    $('<a class="remove_fields" href="">Remove panel</a>').insertBefore($(event.target))

  remove_fields = () ->
    alert('hello')
    #$(this).closest('.nested_fields').css('border', '1px solid red')

  $(document).on 'click', '.add_fields', (event) ->
    add_fields(event)

  $(document).on 'click', '.remove_fields', (event) ->
    #add_fields(event)
    remove_fields()
