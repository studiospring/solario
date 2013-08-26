# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#alert('test');
#creates link to remove form field. Requires accepts_nested_attributes_for association. See railscast #197
jQuery ->
  window.remove_fields = (link) -> 
    $(link).prev("input[type=hidden]").val("1")
    $(link).closest('.nested_fields').hide()

#add fields. See railscast #197
  window.add_fields = (link, association, content) ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + association, "g")
    $(link).before(content.replace(regexp, new_id))
    $('input.dob').datepicker({
      minDate: null,
      yearRange: 'c-100:c'
    });

