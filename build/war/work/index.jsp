<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <html>
    <head>
    <title>80 friends</title>
    <link rel="icon" type="image/png" href="../images/muse-favicon.png"/>
    <link rel="stylesheet" type="text/css" href="css/80friends.css"/>
 	<link rel="icon" type="image/png" href="images/globe.png" />
 
	<script src="js/jquery/jquery.js"></script>
	<script src="js/json2.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
 	<script src="js/80f.js"></script>
	
    </head>
    <body style="margin-left:5%;margin-right:5%">
    <div style="padding-top:20px;margin:auto;width:800px;position:relative">
    <div id="fb-root"></div>
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
      <button id="map_button" style="" onclick="doFBStuff()">Build your map &nbsp;&nbsp;&nbsp;&rarr;</button>
	<div id="fb_status">
		<img style="height:25px" id="friend_pic0"/>
		<img style="height:25px" id="friend_pic1"/>
		<img style="display:none;height:25px" id="friend_pic2"/>
		<img style="display:none;height:25px" id="friend_pic3"/>
		<img style="display:none;height:25px" id="friend_pic4"/>
		<img style="display:none;height:25px" id="friend_pic5"/>
		<img style="display:none;height:25px" id="friend_pic6"/>
		<img style="display:none;height:25px" id="friend_pic7"/>
		<img style="display:none;height:25px" id="friend_pic8"/>
		<img style="display:none;height:25px" id="friend_pic9"/>&nbsp;
	</div>
	<div id="refresh_icon" style="display:none"><img style="padding:5px" title="Refresh" src="images/refresh.png"></div>
	<div id="countries">&nbsp;</div>  	
	<div id="map"></div>
	<div id="absent_countries"></div>

	<div style="position:relative">
	<br/><button id="match_button" style="display:none;top:10px">Look for friends &nbsp;&nbsp;&nbsp;&rarr;</button>
	</div>
	
	<div>&nbsp;</div>
	<div>&nbsp;</div>
	<hr/>
	<%@include file="footer.jsp"%>
	
	<script>
		// display an empty map first
	    google.load('visualization', '1', {'packages': ['geochart']});
	    google.setOnLoadCallback(drawRegionsMap);
	    // note: chart is global
		function drawRegionsMap() {
	       chart = new google.visualization.GeoChart(document.getElementById('map'));
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
	     
	     // show footer only after map is available, otherwise the footer appears briefly at the top of the page
	     $('#footer').fadeIn();
		}
		
	</script>
	    	    
	</div> <!--  800px -->
    </body>
 </html>
