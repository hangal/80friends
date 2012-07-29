<%@ page language="java" contentType="application/x-javascript; charset=UTF-8"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<%
	String[] codes = request.getParameterValues("code");
	String id = request.getParameter("id");

	System.out.println ("id " + id + " needs " + codes.length + " friends");
	out.println ("{status:0}");
	MongoUtils.addNeeds(id, codes);
%>
