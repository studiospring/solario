# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/
ready = ->
  $('#enable_js').hide()
  $('#new_pv_query .glyphicon').tooltip()
  
  form = $('#new_pv_query')
  form_validation = form.validate# <<<
    #debug: true,
    errorClass: 'alert-warning',
    errorPlacement: (error, element) ->
      element.parent().append(error)# >>>
  #add/remove nested forms without link_to_function (which has been deprecated)# <<<
  add_fields = (event) ->
    #clone fields
    last_fieldset = $('fieldset.nested_fields').last()
    new_fieldset = last_fieldset.clone(true, true)
    count_nested_fieldsets = $('fieldset.nested_fields').length
    #modify elements of cloned fieldset
    new_fieldset.find('.form-group').children().each ->
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
    #reset styling (set compass to default position)
    new_fieldset.find('.icon').removeAttr('style')
    new_fieldset.find('.compass').removeAttr('style')
    new_fieldset.find('.solar-panels').removeAttr('style')

    new_fieldset.insertBefore($('.add_fields'))
    $('<a class="btn btn-default remove_fields" href="">remove panel</a><br />').insertBefore($(event.target))

  remove_fields = (event) ->
    $(event.target).prev('.nested_fields').remove()
    $(event.target).remove()
    
  $(document).on 'click', '.add_fields', (event) ->
    event.preventDefault()
    #this code must come after validation!
    #remove validation error msg
    form_validation.resetForm()
    add_fields(event)

  $(document).on 'click', '.remove_fields', (event) ->
    event.preventDefault()
    remove_fields(event)# >>>
  #animate panel icon# <<<
  $('.bearing_input').change ->
    if form_validation.valid()
      bearing = this.value - 45
      centres_compass = '-18px'
      #use compass div not panel div to apply each rotation in order to separate divs
      icon = $(this).parents('.nested_fields').find('.icon')
      icon.find('.compass').css({
        '-moz-transform':     'translateX(' + centres_compass + ')
                              translateY(' + centres_compass + ') 
                              rotateZ(' + bearing + 'deg)',
        '-webkit-transform':  'translateX(' + centres_compass + ') 
                              translateY(' + centres_compass + ')
                              rotate(' + bearing + 'deg)',
        '-o-transform':       'translateX(' + centres_compass + ')
                              translateY(' + centres_compass + ')
                              rotateZ(' + bearing + 'deg)',
        'transform':          'translateX(' + centres_compass + ')
                              translateY(' + centres_compass + ') 
                              rotateZ(' + bearing + 'deg)',
        'transition':         'transform 1s'
      })
      #optimise viewing angle only after tilt has been added
      if $(this).siblings('.tilt_input').val()
        optimise_viewing_angle(icon)

  $('.tilt_input').change ->
    if form_validation.valid()
      tilt = this.value
      input = this.id
      icon = $(this).parents('.nested_fields').find('.icon')
      icon.find('.compass').children('.solar-panels').css({
        'transform-origin':   '0 top 0',
        '-moz-transform':     'rotateX(' + tilt + 'deg)',
        '-webkit-transform':  'rotateX(' + tilt + 'deg)',
        '-o-transform':       'rotateX(' + tilt + 'deg)',
        'transform':          'rotateX(' + tilt + 'deg)',
        'transition':         'transform 1s'
      })
      #
      unless typeof(icon.find('.compass').css('transform')) == 'undefined'
        optimise_viewing_angle(icon)

  optimise_viewing_angle = (icon) -># <<<
    #if typeof(icon.find('.compass').css('transform')) == 'undefined'
      #return false
    compass = icon.find('.compass')
    #get current bearing
    bearing_matrix = compass.css('transform')
    console.log('bearing_matrix: ' + bearing_matrix)
    values = bearing_matrix.split('(')[1].split(')')[0].split(',')
    a = values[0]
    b = values[1]
    bearing = Math.round(Math.atan2(b,a) * (180 / Math.PI)) + 45
    new_compass_angle = 45
    if  0 < bearing <= 90
      new_compass_angle = 90
    else if 90 < bearing <= 180
      new_compass_angle = 105
    else if 180 < bearing <= 225
      new_compass_angle = 10
    else if -134 < bearing <= -90 #bearing calculation switches to )egative values here
      new_compass_angle = 10
    else if -90 < bearing <= 0
      new_compass_angle = -80
    #rotate compass for best viewing angle
    icon.css({
      '-moz-transform':     'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      '-webkit-transform':  'rotateX(70deg) rotate(' + new_compass_angle + 'deg)',
      '-o-transform':       'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      'transform':          'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      'transition':         'transform 2s'
    })# >>>
# >>>
  #prevent double submit
  $('#new_pv_query').submit ->
    $('input[type=submit]', this).addClass('.test')

    $('input[type=submit]', this).attr('disabled', 'disabled')
  #reenable submit button
  $('input.form-control').change ->
    if $('input[type=submit]').attr('disabled') == 'disabled' && form.valid() 
      $('input[type=submit]').removeAttr('disabled')
  #rules must be here to work!
  $('#pv_query_postcode_id').rules(# <<<
    'add',
      required: true,
      digits: true,
      minlength: 4,
      maxlength: 4
  )
  $('.bearing_input').rules(
    'add',
      required: true,
      digits: true,
      min: 0,
      max: 360
  )
  $('.tilt_input').rules(
    'add',
      required: true,
      digits: true,
      min: 0,
      max: 90
  )
  $('.area_input').rules(
    'add',
      required: true,
      number: true,
      min: 0
  )# >>>
#get turbolinks to load js on page load, not second time around
$(document).ready(ready)
$(document).on('page:load', ready)
