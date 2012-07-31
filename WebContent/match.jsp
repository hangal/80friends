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
    <div style="padding-top:20px;margin:auto;width:800px;position:relative">
    <div style="background-color:white;padding:2% 10px 2% 10px">
	<h1>Around the World with 80 Friends</h1> 

<%    
	String[] codes = request.getParameterValues("code");
	String id = request.getParameter("id");
	if (codes == null) {
		out.println ("What countries would you like to connect to? Please retry.");
		return;
	}
	System.out.println ("id " + id + " needs " + codes.length + " friends");
	MongoUtils.addNeeds(id, codes);
	Collection<Match> matches = MongoUtils.generateMatches(id);
	if (matches.size() == 0) { %>
	No matches right now, but we're watching out in <%=codes.length %> countries for you. 
	As soon as you can be paired with someone who is looking for a friend from your country, 
	we will inform both of you, and you can decide whether to connect on Facebook.
	<div style="text-align:center">Happy friending!</div>
	 
	<% } else { %>
	Yay! We found the following matches for you:<p>
	<%
	// note: we are prohibited from offering to make friends directly 
		for (Match m: matches) {
			out.println ("<div style=\"text-align:center;font-size:10pt;margin-left:150px;float:left;width:180px\"><a href=\"http://facebook.com/" + m.id1 + "\"><img src=\"http://graph.facebook.com/" + m.id1 + "/picture\"/><br/>" + m.name1 + "</a><br/>");
			for (String s: m.id1_locs)
				out.println (Countries.getCountryAsHtml(s));
			out.println (" </div>  ");
			out.println (" <div style=\"float:left;width:100px;position:relative;top:30px;border-top:1px solid rgba(127,127,127,0.5)\"></div>"); // div just for the line
			out.println ("<div style=\"text-align:center;font-size:10pt;margin-left:30px;float:left;width:150px\"><a href=\"http://facebook.com/" + m.id2 + "\"><img src=\"http://graph.facebook.com/" + m.id2 + "/picture\"/><br/>" + m.name2 + "</a><br/>");
			for (String s: m.id2_locs)
				out.println (Countries.getCountryAsHtml(s));
			out.println ("</div>");
			out.println ("<div style=\"clear:both\"></div><br/>");
	    }
	int remaining = codes.length - matches.size();
	if (remaining > 0) {
%>	
	We are continuing to look out in <%=remaining %> countries for you. Happy friending!
<% } 
}%>
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