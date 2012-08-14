package edu.stanford.eightyfriends;

import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

import com.google.gson.Gson;

/** all info about a person */
public class PersonInfo implements Comparable<PersonInfo>{

	public String id, name;
	public Set<String> ownLocs = new LinkedHashSet<String>(); // own locations
	public Map<String, Set<String>> locationToFriends = new LinkedHashMap<String, Set<String>>(); // map of country code -> all friends connected to that country 
	public Map<String, Set<String>> friendToLocations = new LinkedHashMap<String, Set<String>>();
	public Set<String> allLocs = new LinkedHashSet<String>(); // all locs, own + all friends
	public Map<String, String> friendIdToName = new LinkedHashMap<String, String>();
	
	private PersonInfo() { } // use factory method
	
	/* gets person info and also populates the score table for this id */
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

		// always update scores table
		MongoUtils.setScore(id, pi.getScore());
		
		return pi;
	}
	
	public int compareTo (PersonInfo pi) {
		return pi.getScore() - this.getScore(); 
	}
	
	public int getScore()
	{
		return allLocs.size();
	}
	
	public String toJson() {
		return new Gson().toJson(this);
	}
	
	public String toString()
	{
		return "Info for " + this.name + ": " + allLocs.size() + " countries";
	}
}
