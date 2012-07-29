<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <html>
    <head>
      <title>Facebook Login Page</title>
    <link rel="icon" type="image/png" href="../images/muse-favicon.png"/>
    <link rel="stylesheet" type="text/css" href="css/80friends.css"/>
    <script type='text/javascript' src='https://www.google.com/jsapi'></script>
 	<link rel="icon" type="image/png" href="images/globe.png" />
 
	<script src="js/jquery/jquery.js"></script>
	<script src="js/json2.js"></script>
	<script src="js/all.js"></script>
    </head>
    <body style="margin-left:5%;margin-right:5%">
    <div style="padding-top:20px;margin:auto;width:800px;position:relative">
    
    <script>
    var chart;
	var CHART_OPTS = {legend: 'none', height:600, width:800};   
    (function(d) {
           var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
           js = d.createElement('script'); js.id = id; js.async = true;
           js.src = "//connect.facebook.net/en_US/all.js";
           d.getElementsByTagName('head')[0].appendChild(js);
         })(document);
  </script>

	<h1>Around the World with 80 Friends</h1> 
      <button style="position:absolute;left:600px;top:30px;width:200px;height:40px;z-index:100000" onclick="doFBStuff()">Build your map &nbsp;&nbsp;&nbsp;&rarr;</button>
	<div id="fb_status" style="margin-top:-20px;font-size:10pt"> &nbsp;</div>  <div id="countries">&nbsp;</div>  	
	<div id="map"></div>
	<hr/>
	<div id="footer">
	<a href="about.html">About</a> &nbsp;&nbsp;&nbsp;
	<a href="help.html">Help </a>&nbsp;&nbsp;&nbsp;
	<a href="http://change.org">Change.org</a> &nbsp;&nbsp;&nbsp;
	<a href="http://mobisocial.stanford.edu">Stanford Mobisocial Lab</a> &nbsp;&nbsp;&nbsp;
	<a href="http://peace.facebook.com">Peace on Facebook</a> &nbsp;&nbsp;&nbsp;
	</div>
	<script>
	    google.load('visualization', '1', {'packages': ['geochart']});
	    google.setOnLoadCallback(drawRegionsMap);
		function drawRegionsMap() {
	     chart = new google.visualization.GeoChart(document.getElementById('map'));
	     var data = new google.visualization.DataTable();
	       data.addColumn('string', 'Country'); // Implicit domain column.
	       data.addColumn('number', 'Popularity'); // Implicit data column.
	       var data = new google.visualization.DataTable();
	       data.addColumn('string', 'Month'); // Implicit domain column.
	       data.addColumn('number', 'Sales'); // Implicit data column.
	       
	       var data_table = google.visualization.arrayToDataTable([['Country', 'Popularity']]);
	       
	       var view = new google.visualization.DataView(data_table);
	       view.setColumns([0, 1, {
	           type: 'string',
	           role: 'tooltip',
	           calc: function () {
	               return 'ABCDE';
	           }
	       }]);
	       
	     chart.draw(view, CHART_OPTS);
		 google.visualization.events.addListener(chart, 'regionClick', regionClickHandler);
		}
		
	
	</script>
	    	    
	    </div>
    </body>
 </html>
