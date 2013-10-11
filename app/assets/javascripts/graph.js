//= require jsapi
//= require default
//= require visualization
//= require graph3d-min

var data = null;
var graph = null;

google.load("visualization", "1");

// Set callback to run when API is loaded
google.setOnLoadCallback(drawVisualization); 

function custom(x, y) {
  return Math.sin(x/50) * Math.cos(y/50) * 50 + 50;
}

// Called when the Visualization API is loaded.
function drawVisualization() {
  // Create and populate a data table.
  data = new google.visualization.DataTable();
  data.addColumn('number', 'x');
  data.addColumn('number', 'y');
  data.addColumn('number', 'value');

  // create some nice looking data with sin/cos
  var steps = 25;  // number of datapoints will be steps*steps
  var axisMax = 314;
  axisStep = axisMax / steps;
  for (var x = 0; x < axisMax; x+=axisStep) {
    for (var y = 0; y < axisMax; y+=axisStep) {
      var value = custom(x,y);
      data.addRow([x, y, value]);
    }
  }

  // specify options
  options = {width:  "500px", 
             height: "400px",
             style: "surface",
             showPerspective: true,
             showGrid: true,
             showShadow: false,
             keepAspectRatio: true,
             verticalRatio: 0.5
             };

  // Instantiate our graph object.
  graph = new links.Graph3d(document.getElementById('mygraph'));
  
  // Draw our graph with the created data and options 
  graph.draw(data, options);
}

