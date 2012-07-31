package edu.stanford.eightyfriends;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

public class Util {

	static Logger log = Logger.getLogger(Util.class);

    public static String stackTrace(Throwable t)
    {
        StringWriter sw = new StringWriter(0);
        PrintWriter pw = new PrintWriter(sw);
        t.printStackTrace(pw);
        pw.close();
        return sw.getBuffer().toString();
    }

    /** takes in a map K,V and returns a List of Pairs <K,V> sorted by (descending) value */
    public static<K,V extends Comparable<? super V>> List<Pair<K,V>> sortMapByValue(Map<K,V> map)
    {
        List<Pair<K,V>> result = new ArrayList<Pair<K,V>>();
        for (Map.Entry<K,V> e: map.entrySet())
            result.add(new Pair<K,V>(e.getKey(), e.getValue()));
        Util.sortPairsBySecondElement(result);
        return result;
    }

    /** takes in a map K,List<V> and returns a new Map of Pairs <K,List<V>> sorted by (descending) size of the lists.
     * by sorting, we just mean that a linkedhashmap is returned which can be iterated over in sorted order. */
    public static<K,V> Map<K,Collection<V>> sortMapByListSize(Map<K,Collection<V>> map)
    {
    	List<Pair<K,Integer>> counts = new ArrayList<Pair<K,Integer>>();
    	for (Map.Entry<K,Collection<V>> e: map.entrySet())
    		counts.add(new Pair<K,Integer>(e.getKey(), e.getValue().size()));
    	Util.sortPairsBySecondElement(counts);
    	Map<K,Collection<V>> result = new LinkedHashMap<K, Collection<V>>();
    	for (Pair<K,Integer> p: counts)
    	{
    		K k = p.getFirst();
    		result.put(k, map.get(k));
    	}
    	return result;
    }
    
    /** sorts in decreasing order of second element of pair */
    public static<S,T extends Comparable<? super T>> void sortPairsBySecondElement(List<Pair<S,T>> input)
    {
        Collections.sort (input, new Comparator<Pair<?,T>>() {
            public int compare (Pair<?,T> p1, Pair<?,T> p2) {
                T i1 = p1.getSecond();
                T i2 = p2.getSecond();
                return i2.compareTo(i1);
            }
        });
    }

}
