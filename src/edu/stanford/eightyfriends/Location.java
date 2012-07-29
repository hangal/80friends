package edu.stanford.eightyfriends;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;

public class Location {
	public String code, descr;
	
	public String toJsonStrubg() {
		return new Gson().toJson(this);
	}

	public JSONObject toJSONObject() throws JSONException {
		JSONObject j = new JSONObject();
		j.put ("code", code);
		j.put("descr", descr);
		return j;
	}

	public String toString() 
	{ 
		try {
			return toJSONObject().toString();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "JSON Exception: " + e;
		} 
	}
}
