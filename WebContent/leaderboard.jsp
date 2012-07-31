<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>

<html>
    <head>
      <title>80 friends</title>
 	<link rel="icon" type="image/png" href="images/globe.png" />
    <link rel="stylesheet" type="text/css" href="css/80friends.css"/>
    <script type='text/javascript' src='https://www.google.com/jsapi'></script>
 	<link rel="icon" type="image/png" href="images/globe.png" />
 
	<script src="js/jquery/jquery.js"></script>
	<script src="js/json2.js"></script>
	<script src="js/80f.js"></script>
    </head>
    <body style="margin-left:5%;margin-right:5%">
    
    <div id="fb-root"></div>
    
    <div style="padding-top:20px;margin:auto;width:800px;position:relative">
    <div style="background-color:white;padding:2% 10px 2% 10px">
	<h1>Around the World with 80 Friends<br/>
	<span style="font-size:50%">Leaderboard in your network</span> </h1>

<%
	String id = request.getParameter("id");
	if (id == null)
		id = (String) session.getAttribute("my_id");
	List<PersonInfo> members = MongoUtils.generateLeaderboard(id);
	int idx = 0;
	for (PersonInfo p: members)
	{
		out.println ("<hr/>");

		// 3 parts to each entry: rank, 
		out.println ("<div style=\"float:left;width:50px;font-size:30pt;margin-top:10px\"><span style=\"color:gray\">" + (++idx) + "</div>");

		out.println ("<div style=\"float:left;width:150px;text-align:center;font-size:10pt;margin-left:50px;\"><a href=\"http://facebook.com/" + p.id + "\"><img src=\"http://graph.facebook.com/" + p.id + "/picture\"/><br/>" + p.name + "</a><br/>");
		Set<String> locs = p.ownLocs;
		for (String code: locs)
			out.println (Countries.getCountryAsHtml(code, null /* no id needed */));
		out.println (" </div>  ");
		
		out.println ("<div style=\"float:left;width:450px;font-size:10pt;margin-left:50px;\">");
		int num = p.allLocs.size();
		out.println ("<span style=\"color:gray\">Connected to " + num + " " + ((num != 1) ? "countries":"country") + "</span>");
		out.println ("<br/>");
		for (String code: p.allLocs)
			out.println (Countries.getCountryAsHtml(code, null /* no id needed */));
		out.println (" </div>  ");
		out.println (" <div style=\"clear:both\"></div>  ");
	}
	
	PersonInfo p = PersonInfo.computePersonInfo(id);
	int n_countries = p.allLocs.size();
	String descr = n_countries + " " + (n_countries > 1 ? "countries":"country");
	String message = "I am connected to " + descr + " through Facebook. What\\'s your score?";
%>	
<hr/>

<div style="position:relative">
<button style="left:560px" onclick="postToFeed()">Invite your friends&nbsp;&nbsp;&nbsp;&rarr;</button>
</div>
<br>
<br/>
<br/>


	<script type="text/javascript">
	(function(d) {
        var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
        js = d.createElement('script'); js.id = id; js.async = true;
        js.src = "//connect.facebook.net/en_US/all.js";
        d.getElementsByTagName('head')[0].appendChild(js);
      })(document);
	
	  window.fbAsyncInit = function() {
	        FB.init({
	      	  appId: ((window.location.hostname.indexOf('localhost') >= 0) ? '345533228861202' : '427320467320919'), // first is test app on localhost, second for muse.stanford.edu
	          //  auth_response: auth,
	            status     : true, 
	            cookie     : true,
	            xfbml      : true,
	            oauth      : true,
	          });
	    };
	    
    function postToFeed() {
        // calling the API ...
        var obj = {
          method: 'feed',
          link: 'http://bit.ly/80friends',
          picture: 'http://muse.stanford.edu:8080/80friends/images/globe.png',
          name: 'Around the World with 80 Friends',
          caption: 'Make connections around the world',
          description: '<%=message%>'
        };

        function callback(response) {
        	// ideally we should check if the user pressed cancel instead of share.
        	// See http://developers.facebook.com/docs/reference/dialogs/feed/
        	$.ajax ({  
        		url: '/80friends/ajax/log.jsp',
        		type: 'POST',
        		data: {id:FB.getUserID(), message: 'Posted to feed'},
        		dataType:'json',
        		success: function(resp) { 
        		}
        	});
        }

        FB.ui(obj, callback);
      }
    </script>
	</div>
<hr/>
<%@include file="footer.jsp"%>
</div>
<script type="text/javascript">
$(document).ready(function() { 
    $('#footer').fadeIn();
});</script>	
</body>
</html>