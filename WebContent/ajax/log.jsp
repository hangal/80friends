<%@page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<% 
	String my_id = (String) session.getAttribute("my_id");
	String name = MongoUtils.getNameForId(my_id);
	JSPHelper.log ("USER: "+ my_id + " " + name + " " + request.getParameter("message"));
	out.println("{}");
%>