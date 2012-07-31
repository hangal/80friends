package edu.stanford.eightyfriends;

import org.apache.log4j.Logger;

public class JSPHelper {
	static Logger log = Logger.getLogger(Util.class);
	public static void log (String s)
	{
		log.info ("USER LOG: " + s);
	}
}
