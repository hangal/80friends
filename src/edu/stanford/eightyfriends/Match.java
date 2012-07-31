package edu.stanford.eightyfriends;

import java.util.Set;

public class Match {
	public String id1, id2;
	public String name1, name2;
	public Set<String> id1_locs, id2_locs;
	
	public int hashCode() { return id1.hashCode() ^ id2.hashCode(); }
	public boolean equals(Object o)
	{
		Match other = (Match) o;
		return id1.equals(other.id1) && id2.equals(other.id2);
	}
}
