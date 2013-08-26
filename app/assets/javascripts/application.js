// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

alert('test');
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

