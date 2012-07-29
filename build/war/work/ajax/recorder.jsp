<%@ page language="java" contentType="application/x-javascript; charset=UTF-8"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<%
	String json = request.getParameter("body");
	JSONObject o = new JSONObject(json);
	Location hometownCountry = null, locationCountry = null;
	String id = "?", name = request.getParameter("friendName");
	String hid = "?", hname = "?";
	String lid = "?", lname = "?";

	System.out.println ("json for " + name + " = " + json);

	try {
		JSONObject about = o.getJSONObject("about");
		id = about.getString("id");
		name = about.getString("name");
		try { 
			hname = about.getJSONObject("hometown").getString("name");
			hid = about.getJSONObject("hometown").getString("id");
			hometownCountry = Util.countryFromLocation(hname, hid);
		} catch (Exception e) { }
		
		try { 
			lname = about.getJSONObject("location").getString("name");
			lid = about.getJSONObject("location").getString("id");
			locationCountry = Util.countryFromLocation(lname, lid);
		} catch (Exception e) { }
		
	} catch (Exception e)  { }

	System.out.println ("id = " + id + " name = " + name + " country = " + hometownCountry + " (" + hname + ";" + hid + ") location = " + locationCountry + " (" + lname + ";" + lid + ")");
	JSONArray ja = new JSONArray();
	if (hometownCountry != null)
		ja.put(0, hometownCountry.toJSONObject());
	if (locationCountry != null)
		ja.put(1, locationCountry.toJSONObject());

	out.println (ja);
//	MongoUtils.add(json);
%>
