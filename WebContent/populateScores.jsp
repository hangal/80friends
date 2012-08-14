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
    
    <script src="js/cufon-yui.js" type="text/javascript"></script>
    <script src="js/London2012.font.js" type="text/javascript"></script>
 	<script type="text/javascript">
            Cufon.replace('h1'); // Works without a selector engine
    </script>
 
	<script src="js/jquery/jquery.js"></script>
	<script src="js/json2.js"></script>
	<script src="js/80f.js"></script>
    </head>
    <body style="margin-left:5%;margin-right:5%">
    


<%
	int n = MongoUtils.repopulateScores();
	out.println (n + " scores populated");
%>	
<hr/>

</body>
</html>