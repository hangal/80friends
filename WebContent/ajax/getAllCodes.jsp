<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<%
	List<Location> list = new ArrayList<Location>();
	for (String code: Countries.codeToCountry.keySet())
	{
		String descr = Countries.codeToCountry.get(code);
		Location L = new Location();
		L.code = code; L.descr = descr.toUpperCase(); 
		list.add(L);
	}

	String json = new Gson().toJson(list);
	out.println (json);
%>
