package edu.stanford.eightyfriends;
import java.net.UnknownHostException;
import java.util.Set;

import com.mongodb.Mongo;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import com.mongodb.DBCursor;
import com.mongodb.MongoException;

public class MongoUtils {

	public static void add(String json) throws UnknownHostException, MongoException
	{
		Mongo m = new Mongo( "localhost" );		
		DB db = m.getDB("test");
		Set<String> colls = db.getCollectionNames();

		for (String s : colls) {
		    System.out.println(s);
		}
		
		DBCollection coll = db.getCollection("test");
		
		DBObject myDoc = coll.findOne();
		System.out.println(myDoc);
		
		BasicDBObject o = (BasicDBObject) com.mongodb.util.JSON.parse(json);		
        coll.insert(o);
	}
}
