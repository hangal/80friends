<%@page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<% 
	String id = request.getParameter("id");
	boolean id_exists = MongoUtils.haveIdInFriendsTable(id);
	
	// somehow to get the below to work with jq ajax json, I have to use double quotes around id_exists and no quotes around 'true' - jq json parsing appears to be very finnicky
	//String x = "{\"id_exists\": " + (id_exists ? "true":"false") + "}";
	//out.println (x);

	
	// therefore switched to official printing via jsonobject
	JSONObject j = new JSONObject();
	j.put("id_exists", true);
	out.println (j.toString());
%>