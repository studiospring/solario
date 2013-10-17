# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/
$ ->
  data = null
  graph = null

# Called when the Visualization API is loaded.
  drawVisualization = () ->
    # Create and populate a data table.
    data = new google.visualization.DataTable
    data.addColumn('number', 'hour')
    data.addColumn('number', 'month')
    data.addColumn('number', 'kW')

    dni_string = $("#mygraph").data("dni")
    dni_array = dni_string.split(" ").map(parseFloat)
    for month in [1..12]
      for hour in [6..16] by 1
        kW = dni_array.shift()
        row = [hour, month, kW]
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
      cameraPosition: {"horizontal": 5.6, "vertical": 0.25, "distance": 1.7}

    # Instantiate our graph object.
    graph = new links.Graph3d(document.getElementById('mygraph'))

    # Draw our graph with the created data and options 
    graph.draw(data, options)

# Set callback to run when API is loaded
  google.setOnLoadCallback(drawVisualization)
