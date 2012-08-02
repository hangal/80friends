<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<%
	String json = request.getParameter("body");
	JSONObject user_details = new JSONObject(json);
	String my_id = request.getParameter("my_id");
	String[] ids = request.getParameterValues("ids[]"), names = request.getParameterValues("friendNames[]");

	// hack alert: if my_id == id, we know that the rest of this id's data is coming soon. clear existing data for this user in db
	if (my_id != null && my_id.equals(ids[0])) {
		JSPHelper.log("USER initiated lookup: " + names[0] + " (" + ids[0] + ") from "  + request.getRemoteHost() + " using " + request.getHeader("user-agent"));
		MongoUtils.wipeDataForId(my_id);
	}
	
	JSONObject result = new JSONObject();
	
	for (String id: ids)
	{
		Location hometownCountry = null, locationCountry = null;
		String hid = "?", hname = "?";
		String lid = "?", lname = "?";

		String name = "?";
		try {
			JSONObject o = user_details.getJSONObject(id);

			// o contains name: and 
			// locations: ...
			
			// set the name first
			name = o.getString("name");
			MongoUtils.setName(id, name);

			// now read off locations
			try { 
				hname = o.getJSONObject("hometown").getString("name");
				hid = o.getJSONObject("hometown").getString("id");
				hometownCountry = Countries.countryFromLocation(hname, hid);
			} catch (Exception e) { }
			
			try { 
				lname = o.getJSONObject("location").getString("name");
				lid = o.getJSONObject("location").getString("id");
				locationCountry = Countries.countryFromLocation(lname, lid);
			} catch (Exception e) { }
			
		} catch (Exception e)  { }
	
	JSPHelper.log.info ("my_id = " + my_id + " id = " + id + " name = " + name + " country = " + hometownCountry + " (" + hname + ";" + hid + ") location = " + locationCountry + " (" + lname + ";" + lid + ")");
	
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

	result.put (id, ja);
	}
	out.println (result);
//	MongoUtils.add(json);
%>