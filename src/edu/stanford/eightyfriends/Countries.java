package edu.stanford.eightyfriends;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Countries {
	static Logger log = Logger.getLogger(Countries.class);

	public static Map<String, String> countryToCode, codeToCountry;
	static { 
		try  { readCountryCodes("countrycodes.txt"); } 
		catch (Exception e) { log.error("Unable to read countries list!"); }
	}
		
    public static void readCountryCodes(String file) throws UnsupportedEncodingException
    {
    	countryToCode = new LinkedHashMap<String, String>();
    	codeToCountry = new LinkedHashMap<String, String>();
    	
    	InputStream is = Util.class.getClassLoader().getResourceAsStream(file);
    	Reader r = new InputStreamReader(is, "UTF-8");
        try {
            LineNumberReader lnr = new LineNumberReader(r);
            while (true)
            {
                String line = lnr.readLine();
                if (line == null)
                {
                    lnr.close();
                    break;
                }
                line = line.trim();
                if (line.startsWith("#") || line.length() == 0)
                    continue;
                
                // line: ARGENTINA;AR

                StringTokenizer st = new StringTokenizer(line, ";");
                String country = st.nextToken();
                String code = st.nextToken();
                countryToCode.put(country.toLowerCase(), code);
                codeToCountry.put(code, country.toLowerCase());
            }
        } catch (IOException e) { log.warn ("Exception reading reader " + r + ": " + e + Util.stackTrace(e)); }

        log.info(countryToCode.size() + " country codes read");
    }
    
    /** returns collection of lines from given file (UTF-8). 
     * trims spaces from the lines, 
     * ignores lines starting with # if ignoreCommentLines is true  
     * @throws JSONException */
    public static JSONObject getJSONFromURL(String url) throws IOException, JSONException
    {
    	HttpURLConnection http = (HttpURLConnection) new URL(url).openConnection();
		InputStream in = http.getInputStream();
		
        LineNumberReader lnr = new LineNumberReader(new InputStreamReader(in, "UTF-8"));
        String json = "";
        while (true)
        {
            String line = lnr.readLine();
            if (line == null)
                break;
            line = line.trim();
            json += line;
        }
        
    	JSONObject o = new JSONObject(json);

        return o;
    }

    
    public static Location countryFromLocation(String country, String id) throws IOException, JSONException
	{	
		boolean found = false;
		
		country = country.toLowerCase();
		if (countryToCode.containsKey(country))
			found = true;
		
		if (!found)
		{
			country = country.replaceAll(".*, ", "");
			if (countryToCode.containsKey(country))
				found = true;
		}
		
		if (found)
		{
			String code = countryToCode.get(country);
			Location L = new Location();
			L.code = code; L.descr = country.toUpperCase(); 
			return L;
		}
		
		// try to find country from the id
		// refs: http://stackoverflow.com/questions/8427702/location-lat-long-using-facebook-api
		try {
			// first read lat long from fb
			String url = "http://graph.facebook.com/" + id;
			JSONObject j = getJSONFromURL(url);
			JSONObject loc = j.getJSONObject("location");
			double lat = loc.getDouble("latitude");
			double longi = loc.getDouble("longitude");

			// read geocode info from gmaps using this lat, longi
			// http://stackoverflow.com/questions/5864601/find-county-name-for-a-lat-long
			String maps_url = "http://maps.google.com/maps/geo?ll=" + lat + "," + longi;
			JSONObject geo = getJSONFromURL(maps_url);
			JSONArray placemarks = geo.getJSONArray("Placemark");
			for (int i = 0; i < placemarks.length(); i++)
			{
				try {
					/** example placemark: 
						"Placemark": [ {
						    "id": "p1",
						    "address": "1 Dr Carlton B Goodlett Pl, San Francisco, CA 94102, USA",
						    "AddressDetails": {
						   "Accuracy" : 8,
						   "Country" : {
						      "AdministrativeArea" : {
						         "AdministrativeAreaName" : "CA",
						         "Locality" : {
						            "LocalityName" : "San Francisco",
						            "PostalCode" : {
						               "PostalCodeNumber" : "94102"
						            },
						            "Thoroughfare" : {
						               "ThoroughfareName" : "1 Dr Carlton B Goodlett Pl"
						            }
						         }
						      },
						      "CountryName" : "USA",
						      "CountryNameCode" : "US"
						   }
						},

					 */
					JSONObject placemark = placemarks.getJSONObject(i);
					JSONObject a = placemark.getJSONObject("AddressDetails");
					JSONObject c = a.getJSONObject("Country");
					String code = c.getString("CountryNameCode");
					if (!codeToCountry.containsKey(code))
						log.warn ("Placemark has unknown country code " + code); 

					String countryName;
					if (placemark.has("CountryName"))
						countryName = placemark.getString("CountryName");
					else
						countryName = codeToCountry.get(code);
					
					countryName = countryName.toLowerCase();
					if (codeToCountry.containsKey(code))
					{
						log.info ("Yay, id found country " + code + ": " + countryName);
						if (!countryName.equalsIgnoreCase(codeToCountry.get(code)))
							log.warn ("Not equal: " + countryName + " and " + codeToCountry.get(code));
						Location L = new Location();
						L.code = code; L.descr = countryName.toUpperCase(); 
						return L;
					}	
					log.warn ("Placemark has unknown country name " + countryName); 
				} catch (Exception e) {
					log.warn ("Exception parsing placemark for location id " + id + " maps_url = " + maps_url + ": " + e);
				}
			}
		} catch (Exception e) {
			log.warn ("Exception trying to read location for id " + id + ": " + e); 
		}			
		return null;
	}

    public static String getCountryAsHtml(String code)
    {
    	return getCountryAsHtml(code, null);
    }
    
    /* returns html for the country code */
    public static String getCountryAsHtml(String code, String id)
    {
    	String s = "<img class=\"flag\" ";
    	if (id != null)
    		s += "id=\"" + id + "\" ";
    	s += "title=\"" + Countries.codeToCountry.get(code).toUpperCase() + "\" ";
    	s += "src=\"http://flagpedia.net/data/flags/mini/" + code.toLowerCase() + ".png\"/> ";
    	return s;
    }

}
