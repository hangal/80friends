<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<%
	String json = request.getParameter("body");
	JSONObject o = new JSONObject(json);
	Location hometownCountry = null, locationCountry = null;
	String my_id = request.getParameter("my_id");
	String my_name = request.getParameter("my_name");
	String id = request.getParameter("id"), name = request.getParameter("friendName");
	String hid = "?", hname = "?";
	String lid = "?", lname = "?";

	// hack alert: if my_id == id, we know that the rest of this id's data is coming soon. clear existing data for this user in db
	if (my_id != null && my_id.equals(id))
		MongoUtils.wipeDataForId(my_id);

	if (my_id != null)
		session.setAttribute("my_id", my_id);
//	System.out.println ("json for " + name + " = " + json);
	

			MongoUtils.setName(id, name);
	
	try {
		JSONObject about = o.getJSONObject("about");
		id = about.getString("id");
		name = about.getString("name");
		try { 
			hname = about.getJSONObject("hometown").getString("name");
			hid = about.getJSONObject("hometown").getString("id");
			hometownCountry = Countries.countryFromLocation(hname, hid);
		} catch (Exception e) { }
		
		try { 
			lname = about.getJSONObject("location").getString("name");
			lid = about.getJSONObject("location").getString("id");
			locationCountry = Countries.countryFromLocation(lname, lid);
		} catch (Exception e) { }
		
	} catch (Exception e)  { }

	System.out.println ("my_id = " + my_id + " id = " + id + " name = " + name + " country = " + hometownCountry + " (" + hname + ";" + hid + ") location = " + locationCountry + " (" + lname + ";" + lid + ")");
	
	// maybe call clearFriends otherwise?
	if (!my_id.equals(id))
		MongoUtils.addFriend(my_id, id);			
	
	MongoUtils.clearLocations(id);
	if (hometownCountry != null)
		MongoUtils.addLocation (id, hometownCountry.code);
	if (locationCountry != null)
		MongoUtils.addLocation (id, locationCountry.code);
	
	JSONArray ja = new JSONArray();
	if (hometownCountry != null)
		ja.put(0, hometownCountry.toJSONObject());
	if (locationCountry != null)
		ja.put(1, locationCountry.toJSONObject());

	out.println (ja);
//	MongoUtils.add(json);
%>