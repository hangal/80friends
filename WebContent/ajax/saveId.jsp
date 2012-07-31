<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="org.json.*"%>
<% 
// saves my_id in the session
session.setAttribute("my_id", request.getParameter("id")); 

// status not really used, but still put it
JSONObject o = new JSONObject();
o.put("status", 0);
out.println (o.toString()); 
%>