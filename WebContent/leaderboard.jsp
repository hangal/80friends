<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>

<html>
    <head>
      <title>80 friends</title>
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
	<h1>Around the World with 80 Friends<br/>
	<span style="font-size:50%">Leaderboard</span> </h1>

<%
	String id = request.getParameter("id");
	if (id == null)
		id = (String) session.getAttribute("my_id");
	List<PersonInfo> members = MongoUtils.generateLeaderboard(id);
	int idx = 0;
	for (PersonInfo p: members)
	{
		out.println ("<hr style = ><div style=\"float:left;width:150px;font-size:30pt\"><span style=\"color:gray\">" + (++idx) + "</div>");
		out.println ("<div style=\"text-align:center;font-size:10pt;margin-left:150px;float:left;width:150px\"><a href=\"http://facebook.com/" + p.id + "\"><img src=\"http://graph.facebook.com/" + p.id + "/picture\"/><br/>" + p.name + "</a><br/>");
		Set<String> locs = p.ownLocs;
		for (String code: locs)
			out.println (Countries.getCountryAsHtml(code, null /* no id needed */));
		out.println (" </div>  ");
		out.println (" <div style=\"clear:both\"></div>  ");
	}
%>
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