<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>

<html>
    <head>
      <title>Help: 80 friends</title>
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
	<h1>Around the World with 80 Friends: Help</h1>

There are three main things you can do with the current version of 80Friends.
<p>
1. See which countries your friends come from on a world map. Hover on a country to see a count and list of names associated with that country. Throughout this app, we associate a person with the country of his or her hometown AND current location.
Of course, this information is not always entered by everyone, therefore our estimate of the number of countries you reach is a lower bound. We also have to resort to some intelligent guessing when hometowm
or location names are partially filled in without the country code via determining the latitude/longitude and using a reverse geocoder.

<p>
2. You can see a leaderboard of the number of countries that each person in your network is connected to. This is meant to incentivize people to climb the leaderboard by acquiring friends.
<p>
3. Finally and most importantly, 80friends will pair up people who need a connection to each other's countries. This intervention can cause more friendships to be formed. The site <a href="http://peace.facebook.com">Peace on Facebook</a> merely 
charts the number of friendships between antagonistic groups or countries. We wish to go a step further and help people form these friendships.
<p>
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