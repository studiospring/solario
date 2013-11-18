ready = ->
  $('#content').html("<%=j render partial: "results", locals: {output_pa: @output_pa} %>")
  #draw graph# <<<
  data = null
  graph = null
  google.load("visualization", "1")

  custom = (x, y) ->
    Math.sin(x/50) * Math.cos(y/50) * 50 + 50

  drawVisualization = () ->
    alert 'start fn'
    # Create and populate a data table.
    data = new google.visualization.DataTable
    alert 'new g vis'
    data.addColumn('number', 'x')
    data.addColumn('number', 'y')
    data.addColumn('number', 'value')

    ## create some nice looking data with sin/cos
    steps = 25  # number of datapoints will be steps*steps
    axisMax = 314
    axisStep = axisMax / steps

    #data.addRow row for row in axisMax by axisStep
    for x in [0..axisMax] by axisStep
      for y in [0..axisMax] by axisStep
        value = custom(x,y)
        row = [x, y, value]
        data.addRow(row)

    # specify options
    options =
      width:  "500px"
      height: "400px"
      style: "surface"
      showPerspective: true
      showGrid: true
      showShadow: false
      keepAspectRatio: true
      verticalRatio: 0.5

    alert 'graph predraw'
    #fails here
    # Instantiate our graph object.
    graph = new links.Graph3d(document.getElementById('output_pa'))
    alert 'graph instantiated'
    # Draw our graph with the created data and options
    graph.draw(data, options)
    alert 'graph draw'

  drawVisualization()

  $('#reload_page').click ->
    location.reload(true)

$(document).ready(ready)
$(document).on('page:load', ready)
