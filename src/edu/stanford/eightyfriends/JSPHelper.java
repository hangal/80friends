package edu.stanford.eightyfriends;

import org.apache.log4j.Logger;

public class JSPHelper {
	public static Logger log = Logger.getLogger(JSPHelper.class);
	public static void log (String s)
	{
		log.info ("USER LOG: " + s);
	}
}
