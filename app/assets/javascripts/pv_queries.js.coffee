# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/
$ ->
  $('#enable_js').hide()
  #animate panel icon
  #TODO validate and prevent dud values from activating animation
  $('.bearing_input').change ->
    bearing = this.value - 45
    centres_compass = -22
    #use compass div not panel div to apply each rotation to separate divs
    input = this.id
    alert $('#' + input).parent().find('.compass').attr('class')
    $('#' + input).parent().find('.compass').css({
      '-moz-transform':     'translateX(' + centres_compass + 'px)
                            translateY(' + centres_compass + 'px) 
                            rotateZ(' + bearing + 'deg)',
      '-webkit-transform':  'translateX(' + centres_compass + 'px) 
                            translateY(' + centres_compass + 'px)
                            rotateZ(' + bearing + 'deg)',
      '-o-transform':       'translateX(' + centres_compass + 'px)
                            translateY(' + centres_compass + 'px)
                            rotateZ(' + bearing + 'deg)',
      'transform':          'translateX(' + centres_compass + 'px)
                            translateY(' + centres_compass + 'px) 
                            rotateZ(' + bearing + 'deg)',
      'transition':         'transform 1s'
    })
  $('tilt_input' ).change ->
    tilt = this.value
    input = this.id
    this_icon = $('#' + input).parent()
    this_compass = this_icon.find('.compass')
    #TODO: bug, finds lots of panels
    this_panels = this_icon.find('.panels')
    this_panels.each( (i, el) -> 
      alert 'panel'
      $(el).css({
      #$('.panels').css({
        'transform-origin':   '0 top 0',
        '-moz-transform':     'rotateX(' + tilt + 'deg)',
        '-webkit-transform':  'rotateX(' + tilt + 'deg)',
        '-o-transform':       'rotateX(' + tilt + 'deg)',
        'transform':          'rotateX(' + tilt + 'deg)',
        'transition':         'transform 1s'
      })
    )
    #get current bearing
    bearing_matrix = this_compass.css('transform')
    values = bearing_matrix.split('(')[1].split(')')[0].split(',')
    a = values[0]
    b = values[1]
    bearing = Math.round(Math.atan2(b,a) * (180 / Math.PI)) + 45
    correction = 0
    if  0 < bearing <= 90
      correction = 45
    else if 90 < bearing <= 180
      correction = -60
    else if 180 < bearing <= 225
      correction = 0
    else if -134 < bearing <= -90 #bearing calculation switches to negative values here
      correction = -90
    else if -90 < bearing <= 0 
      correction = 130
    new_compass_angle = parseInt(45 + correction) #45 is original orientation of compass
    #rotate compass for best viewing angle
    this_icon.css({
      '-moz-transform':     'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      '-webkit-transform':  'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      '-o-transform':       'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      'transform':          'rotateX(70deg) rotateZ(' + new_compass_angle + 'deg)',
      'transition':         'transform 2s'
    })

  data = null
  graph = null

# Called when the Visualization API is loaded.
  drawVisualization = () ->
    # Create and populate a data table.
    data = new google.visualization.DataTable
    data.addColumn('number', 'hour')
    data.addColumn('number', 'month')
    data.addColumn('number', 'kW')

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
  google.setOnLoadCallback(drawVisualization)
