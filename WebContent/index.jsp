<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <html>
    <head>
    <title>80 friends</title>
    <link rel="stylesheet" type="text/css" href="css/80friends.css"/>
 	<link rel="icon" type="image/png" href="images/globe.png" />
 
    <script src="js/cufon-yui.js" type="text/javascript"></script>
    <script src="js/London2012.font.js" type="text/javascript"></script>
 	<script type="text/javascript">
            Cufon.replace('h1'); // Works without a selector engine
    </script>
 	
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

	<div style="float:left">
	<h1>Around the World with 80 Friends</h1> 
	</div>
	<button id="map_button" style="position:absolute;display:none;top:340px;left:280px;font-size:27px;width:300px;height:60px" onclick="see_map_handler()">Map your friends &nbsp;&nbsp;&nbsp;&rarr;</button>
	<div id="top_right">
	</div>
	<div style="clear:both"></div>
	
    <div id="fb_status">
	</div>
	<div style="clear:both"></div>

	<div style="position:relative">
	<div id="countries">&nbsp;</div>  	
	<div id="refresh_icon" onclick="populate_friends_anew()" style="display:none"><img style="padding:5px" title="Refresh" src="images/refresh.png"></div>
	<div id="map"></div>
	<div style="position:relative;margin:0% 20% 0% 20%">
		<br/>
	 	<button class="after_flags" id="invite_button" style="float:left;display:none;" onclick="invite_button_clicked()">Tell your friends</button>
		<button class="after_flags" id="compare_button" onclick="window.open('leaderboard')" style="float:right;display:none;">See your rank</button>
		<br/>
		<div style="clear:both"></div>
	</div>
	</div>
	
	<div id="absent_countries"></div>

	<div style="position:relative">
	<br/><button class="after_flags" id="match_button" onclick="show_matches()" style="float:right;display:none;top:10px">Find connections</button>
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
	 //    doFBStuff();
		}
		
	    Cufon.now();
	</script>
	    	    
	</div> <!--  800px -->
    </body>
 </html>
