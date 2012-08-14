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
	<h1>Around the World with 80 Friends</h1>

There are three things you can do with 80 Friends.
<p>
1. See which countries your friends come from on a world map. Hover on a country to see a count and list of names associated with that country. 
We always associate a person with the country of his or her hometown AND current location.
Of course, this information is not always entered by everyone. Therefore our estimate of the number of countries you are connected to is a lower bound. 

<p>
2. See a leaderboard of the number of countries that each person in your network is connected to. 
The leaderboard only shows people in your network who have installed this application.
Invite your friends to join the app to see where they stand.

<p>
3. Most importantly, 80 Friends will help pair up people from different countries.When you click on "Find connections"
you can see other people who have also used the 80 Friends app and need a connection to a country you are affiliated with.
If you form new friendships, click the refresh button when you revisit the map.

We recommend that you first check the profile of the other person, and if appropriate, send them an introductory
message saying you found them using 80 friends. You might explain that you would like to connect with them in the spirit of
being pen friends and exchanging cultural perspectives. 

You can also try to remember friends from specific countries who are not yet connected to you on Facebook and friend them.

<p>
The site <a href="http://peace.facebook.com">Peace on Facebook</a>
charts the number of friendships being formed between antagonistic groups or countries. 
We'd like to go a step further and help people form these friendships.
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