<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<%
	String id = request.getParameter("id");
	PersonInfo pi = PersonInfo.computePersonInfo(id);	
	out.println (pi.toJson());
%>