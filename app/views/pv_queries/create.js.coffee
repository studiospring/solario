$('#content').html("<%=j render partial: "results", locals: {output_pa: @output_pa} %>");
  <%##draw graph %>
  var data = null;
  var graph = null;


<%## Called when the Visualization API is loaded.%>
function drawVisualization() {
    <%#[># Create and populate a data table.<]%>
    data = new google.visualization.DataTable();
    data.addColumn('number', 'hour');
    data.addColumn('number', 'month');
    data.addColumn('number', 'kW');

    if ($("#output_pa").length) {
      alert ('hello');
      var dni_string = $("#output_pa").data("datapoints");
      var dni_array = dni_string.split(" ").map(parseFloat);
      var kW, row, hour, month;
     for (month = 1; month < 13; month+=1) {
      <%#if you change times here, remember to also change them in panel.dni_received_pa%>
        for (hour = 5; hour < 21; hour+=0.5) {
          kW = dni_array.shift();
          row = [hour, month, kW];
          data.addRow(row);
        }
      }

    options = {width:  "500px", 
             height: "450px",
             style: "surface",
             showPerspective: true,
             showGrid: true,
             showShadow: false,
             keepAspectRatio: true,
             verticalRatio: 0.8,
             cameraPosition: {"horizontal": 5.6, "vertical": 0.2, "distance": 1.8}
             };
    }
      <%#[># Instantiate our graph object.<]%>
      graph = new links.Graph3d(document.getElementById('output_pa'));

      <%#[># Draw our graph with the created data and options <]%>
      graph.draw(data, options);
}
drawVisualization();
<%## Set callback to run when API is loaded%>
  <%#google.setOnLoadCallback(drawVisualization);%>
