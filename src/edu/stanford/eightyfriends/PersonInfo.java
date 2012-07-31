package edu.stanford.eightyfriends;

import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

import com.google.gson.Gson;

/** all info about a person */
public class PersonInfo implements Comparable<PersonInfo>{

	String id, name;
	Set<String> ownLocs = new LinkedHashSet<String>(); // own locations
	Map<String, Set<String>> locationToFriends = new LinkedHashMap<String, Set<String>>(); // map of country code -> all friends connected to that country 
	Map<String, Set<String>> friendToLocations = new LinkedHashMap<String, Set<String>>();
	Set<String> allLocs = new LinkedHashSet<String>(); // all locs, own + all friends
	Map<String, String> friendIdToName = new LinkedHashMap<String, String>();
	
	private PersonInfo() { } // use factory method
	
	public static PersonInfo computePersonInfo(String id)
	{
		PersonInfo pi = new PersonInfo();
		pi.id = id;
		pi.name = MongoUtils.getNameForId(id);
		// read own locs
		pi.ownLocs = MongoUtils.readFieldFromCollForSelector("locations", "id", id, "code");
		pi.allLocs.addAll(pi.ownLocs);

		// read all friends
		Set<String> friends = MongoUtils.readFieldFromCollForSelector("friends", "f1", id, "f2");

		// read all my friends' locs
		for (String friendId: friends)
		{
			// get this friend's locs
			Set<String> friendLocs = MongoUtils.readFieldFromCollForSelector("locations", "id", friendId, "code");
			pi.friendToLocations.put (friendId, friendLocs);
			
			// populate friend's name
			pi.friendIdToName.put (friendId, MongoUtils.getNameForId(friendId));
			
			// update locs map with this friend's id
			for (String friendLoc: friendLocs)
			{
				pi.allLocs.add(friendLoc);
				Set<String> set = pi.locationToFriends.get(friendLoc);
				if (set == null)
				{
					set = new LinkedHashSet<String>();
					pi.locationToFriends.put(friendLoc, set);
				}
				set.add(friendId);
			}
		}
				
		return pi;
	}
	
	public int compareTo (PersonInfo pi) {
		return pi.allLocs.size() - allLocs.size(); 
	}
	
	public String toJson() {
		return new Gson().toJson(this);
	}
}
