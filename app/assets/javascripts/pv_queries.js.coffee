# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/

data = null
graph = null
custom = (x, y) ->
  Math.sin(x/50) * Math.cos(y/50) * 50 + 50

# Called when the Visualization API is loaded.
drawVisualization = () ->
  # Create and populate a data table.
  data = new google.visualization.DataTable
  data.addColumn('number', 'x')
  data.addColumn('number', 'y')
  data.addColumn('number', 'value')

  # create some nice looking data with sin/cos
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

  # Instantiate our graph object.
  graph = new links.Graph3d(document.getElementById('mygraph'))

  # Draw our graph with the created data and options 
  graph.draw(data, options)

# Set callback to run when API is loaded
google.setOnLoadCallback(drawVisualization)
