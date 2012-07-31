<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>

<html>
    <head>
      <title>About: 80 friends</title>
    <link rel="icon" type="image/png" href="../images/muse-favicon.png"/>
    <link rel="stylesheet" type="text/css" href="css/80friends.css"/>
    <script type='text/javascript' src='https://www.google.com/jsapi'></script>
 	<link rel="icon" type="image/png" href="images/globe.png" />
 
	<script src="js/jquery/jquery.js"></script>
	<script src="js/json2.js"></script>
	<script src="js/80f.js"></script>
    </head>
    <body style="margin-left:5%;margin-right:5%">
    <div style="padding-top:20px;margin:auto;width:800px;position:relative">
    <div style="background-color:white;padding:2% 10px 2% 10px">
	<h1>Around the World with 80 Friends</h1>

	The original version of this Facebook app was developed by <a href="http://cs.stanford.edu/~hangal">Sudheendra Hangal</a> during the <a href="http://www.change.org/about/hackforchange">Hack for Change hackathon</a> on July 28/29 in San Francisco. 
	The app encourages Facebook users to make friends from as many different countries as possible. This is useful to form a grassroots social network through which information can spread; it is also useful
	for people to have contacts with their counterparts in other countries. 
	
	<p>
	The code for this app is available at <a href="https://github.com/hangal/80friends">https://github.com/hangal/80friends.</a>	
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