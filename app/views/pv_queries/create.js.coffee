$('#content').html("<%=j render partial: "results", locals: {output_pa: @output_pa} %>")
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

drawVisualization() #>>>