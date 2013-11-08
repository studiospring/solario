# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/
$ ->
  $('#enable_js').hide()
  #form validation# <<<
  form_validation = $('#new_pv_query').validate
    debug: true,
    errorClass: 'alert-warning',
    errorPlacement: (error, element) ->
      element.parent().append(error)

  $('#pv_query_postcode_id').rules(
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
  #TODO validate and prevent dud values from activating animation
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
                              rotateZ(' + bearing + 'deg)',
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
      optimise_viewing_angle(icon)

  optimise_viewing_angle = (icon) -># <<<
    compass = icon.find('.compass')
    #get current bearing
    bearing_matrix = compass.css('transform')
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
    else if -134 < bearing <= -90 #bearing calculation switches to negative values here
      new_compass_angle = 10
    else if -90 < bearing <= 0
      new_compass_angle = -80
    #rotate compass for best viewing angle
    icon.css({
      '-moz-transform':     'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      '-webkit-transform':  'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      '-o-transform':       'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      'transform':          'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      'transition':         'transform 2s'
    })# >>>
# >>>
  #draw graph# <<<
  data = null
  graph = null

# Called when the Visualization API is loaded.
  drawVisualization = () ->
    # Create and populate a data table.
    data = new google.visualization.DataTable
    data.addColumn('number', 'hour')
    data.addColumn('number', 'month')
    data.addColumn('number', 'kW')

    if $("#output_pa").length
      dni_string = $("#output_pa").data("datapoints")
      dni_array = dni_string.split(" ").map(parseFloat)
      for month in [1..12]
        #if you change times here, remember to also change them in panel.dni_received_pa
        for hour in [5..20] by 0.5 
          kW = dni_array.shift()
          row = [hour, month, kW]
          data.addRow(row)

      # specify options
      options =
        width:  "500px"
        height: "450px"
        style: "surface"
        showPerspective: true
        showGrid: true
        showShadow: false
        keepAspectRatio: true
        verticalRatio: 0.8
        cameraPosition: {"horizontal": 5.6, "vertical": 0.2, "distance": 1.8}

      # Instantiate our graph object.
      graph = new links.Graph3d(document.getElementById('output_pa'))

      # Draw our graph with the created data and options 
      graph.draw(data, options)

# Set callback to run when API is loaded
  google.setOnLoadCallback(drawVisualization)# >>>
