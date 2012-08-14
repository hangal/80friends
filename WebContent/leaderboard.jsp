<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>

<html>
    <head>
      <title>80 friends</title>
 	<link rel="icon" type="image/png" href="images/globe.png" />
    <link rel="stylesheet" type="text/css" href="css/80friends.css"/>
    <script type='text/javascript' src='https://www.google.com/jsapi'></script>
 	<link rel="icon" type="image/png" href="images/globe.png" />
    
    <script src="js/cufon-yui.js" type="text/javascript"></script>
    <script src="js/London2012.font.js" type="text/javascript"></script>
 	<script type="text/javascript">
            Cufon.replace('h1'); // Works without a selector engine
    </script>
 
	<script src="js/jquery/jquery.js"></script>
	<script src="js/json2.js"></script>
	<script src="js/80f.js"></script>
    </head>
    <body style="margin-left:5%;margin-right:5%">
    
    <div id="fb-root"></div>
    
    <div style="padding-top:20px;margin:auto;width:800px;position:relative">
    <div style="background-color:white;padding:2% 10px 2% 10px">
	<h1>Around the World with 80 Friends</h1>
	<span style="position:relative;top:-15px;">Leaderboard in your network</span>

<%
	String id = request.getParameter("id");
	if (id == null)
		id = (String) session.getAttribute("my_id");
	List<PersonInfo> members = MongoUtils.generateLeaderboard(id);
	int idx = 0;
	for (PersonInfo p: members)
	{
		out.println ("<hr/>");

		// 3 parts to each entry: rank, 
		out.println ("<div style=\"float:left;width:50px;font-size:30pt;margin-top:10px\"><span style=\"color:gray\">" + (++idx) + "</div>");

		out.println ("<div style=\"float:left;width:150px;text-align:center;font-size:10pt;margin-left:50px;\"><a href=\"http://facebook.com/" + p.id + "\"><img src=\"http://graph.facebook.com/" + p.id + "/picture\"/><br/>" + p.name + "</a><br/>");
		Set<String> locs = p.ownLocs;
		for (String code: locs)
			out.println (Countries.getCountryAsHtml(code, null /* no id needed */));
		out.println (" </div>  ");
		
		out.println ("<div style=\"float:left;width:450px;font-size:10pt;margin-left:50px;\">");
		int num = p.allLocs.size();
		out.println ("<span style=\"color:gray\">Connected to " + num + " " + ((num != 1) ? "countries":"country") + "</span>");
		out.println ("<br/>");
		for (String code: p.allLocs)
			out.println (Countries.getCountryAsHtml(code, null /* no id needed */));
		out.println (" </div>  ");
		out.println (" <div style=\"clear:both\"></div>  ");
	}
	
	PersonInfo p = PersonInfo.computePersonInfo(id);
	int n_countries = p.allLocs.size();
	String descr = n_countries + " " + (n_countries > 1 ? "countries":"country");
	String message = "I am connected to " + descr + " through Facebook. What\\'s your score?";
	
	int MAX_TOP = 50; // this is the # of global leaders we will look up
	List<Pair<String, Integer>> globalLeaders = MongoUtils.globalLeaderboard(MAX_TOP);
	String globalLeaderName = "", globalLeaderId = "";
	int globalLeaderScore = 0;
	int my_rank = -1;
	if (globalLeaders.size() > 0)
	{
		Pair<String, Integer> globalLeader = globalLeaders.get(0);
		globalLeaderId = globalLeader.getFirst();
		globalLeaderName = MongoUtils.getNameForId(globalLeaderId);
		globalLeaderScore = globalLeader.getSecond();
		// am i in the global leaders?
		int rank = 0;
		for (Pair<String, Integer> x: globalLeaders)
		{
			rank++;
			if (x.getFirst().equals(id))
				my_rank = rank;
		}
	}

%>	
<hr/>

<div style="position:relative">
<div style="float:left">
	The global leader is <a href="http://www.facebook.com/<%=globalLeaderId%>"><%=globalLeaderName%></a> with connections to <%=globalLeaderScore %> countries.<br/>
	<% if (my_rank > 0) { %>
		You current global rank is #<%=my_rank%>.
	<% } else { %>
		You are currently not in the top #<%=MAX_TOP%> globally.
	<% } %>
</div>
<div style="float:right;width:250px;">
	<button class="after_flags" style="float:right;" onclick="create_invite()">Invite your friends&nbsp;&nbsp;&nbsp;&rarr;</button>
</div>
<div style="clear:both"></div>

<br/>
</div>

	<script type="text/javascript">
	function create_invite() // note: different from invite_button_clicked in 80f.js
	{
		publish_to_fb('<%=message%>');	
	}
	
	(function(d) {
        var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
        js = d.createElement('script'); js.id = id; js.async = true;
        js.src = "//connect.facebook.net/en_US/all.js";
        d.getElementsByTagName('head')[0].appendChild(js);
      })(document);
	
	  window.fbAsyncInit = function() {
	        FB.init({
	      	  appId: ((window.location.hostname.indexOf('localhost') >= 0) ? '345533228861202' : '427320467320919'), // first is test app on localhost, second for muse.stanford.edu
	          //  auth_response: auth,
	            status     : true, 
	            cookie     : true,
	            xfbml      : true,
	            oauth      : true
	          });
	    };
	    
 
    </script>
	</div>
<hr/>
<%@include file="footer.jsp"%>
</div>
<script type="text/javascript">
Cufon.now();

$(document).ready(function() { 
    $('#footer').fadeIn();
});</script>	

</body>
</html>