# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/
$ ->
  alert $("#mygraph").data("dni")

data = null
graph = null
custom = (month, hour) ->
  Math.sin(month/50) * Math.cos(hour/50) * 50 + 50

# Called when the Visualization API is loaded.
drawVisualization = () ->
  # Create and populate a data table.
  data = new google.visualization.DataTable
  data.addColumn('number', 'month')
  data.addColumn('number', 'hour')
  data.addColumn('number', 'kW')

  # create some nice looking data with sin/cos
  steps = 25  # number of datapoints will be steps*steps
  axisMax = 314
  axisStep = axisMax / steps

  #data.addRow row for row in axisMax by axisStep
  for month in [0..axisMax] by axisStep
    for hour in [0..axisMax] by axisStep
      kW = custom(month, hour)
      row = [month, hour, kW]
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
