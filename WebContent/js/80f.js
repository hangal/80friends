    // trim whitespace from either end of s
    var trim = function(s) {
        if (typeof (s) !== 'string')
            return s;

        // trim leading
        while (true) {
            if (s.length == 0)
                break;
            var c = s.charAt(0);
            if (c !== '\n' && c !== '\t' && c !== ' ')
                break;
            s = s.substring(1);
        }
        return s;
    };
    
    /* replacement for Object.keys since IE doesn't support it */
    function own_keys(o) {
    	var result = new Array();
    	for (var f in o)
        {
            try {
                if (!o.hasOwnProperty(f)) // only print properties directly attached this object, not fields in its ancestors
                    continue;
                if (typeof(o[f]) === 'function')
                    continue;
                else
                	result.push(f);
            } catch (e) {
                muse.log ('exception trying to dump object field ' + f + ':' + e);
            }
        }
    	return result;
    }

    function join_keys(o, max) {
    	// ellipsize beyond max
    	var keys = own_keys(o);
    	var ellipsis = true;
    	if (keys.length < max)
    	{
    		// we are able to accomodate all the keys, no need of ellipsis
    		max = keys.length;
    		ellipsis = false;
    	}
    	var s = '';
    	if (keys.length > 1)
    		s = '(' + keys.length + ') ';
    	for (var i = 0; i < max; i++)
    		s += keys[i] + ' ';
    	if (ellipsis)
    		s += '...';
    	return s;
    }
    
    function LOG(s) { if (typeof console != 'undefined' && console.log) console.log(s); }
    var FRIENDS; // list of friend ids and names
    var ALL_CODES = [], CODE_TO_DESCR = {};
    
    var dump_obj = function (o, print_supertype_fields) {
  		if (typeof(o) === 'undefined')
  			return 'undefined';
  		if (typeof(print_supertype_fields) === 'undefined')
  			print_supertype_fields = false;

  		var functions = new Array();

  		var s = 'typeof=' + typeof(o) + ' ';
  		if (o.constructor.name) // often the constructor name is empty because it is an anonymous function; print it only if non-empty
  			s += ' constructor=' + o.constructor.name + ' ';
  		for (var f in o)
  		{
  			try {
  				if (!print_supertype_fields && !o.hasOwnProperty(f)) // only print properties directly attached this object, not fields in its ancestors
  					continue;
  				if (typeof(o[f]) === 'function')
  					functions.push (f); // just write out "function" for functions
  				else
  				{
  					s += f + "=" + o[f] + ' '; // otherwise write out the value
  				}
  			} catch (e) {
  				GM_log ('exception trying to dump object field ' + f + ':' + e);
  			}
  		}
  		
  		if (functions.length > 0)
  			s += functions.length + ' function(s): {';
  		for (var i = 0; i < functions.length; i++)
  		{
  			s += functions[i];
  			if (i < functions.length-1)
  				s += ' ';
  		}
  		if (functions.length > 0)
  			s += '}';
  		
  		return s;
  	};
      
	  var N_FRIENDS_COMPLETE = 0; // tmp throttle
	  var MAX_FRIENDS = 10000;
	  // see if a max= param is specified, should be at the end. 
	  // fragile, under hackathon time pressure!
	  try {
		  var params = window.location.search;
	      if (params && params.indexOf("max=") >= 0)
	      {
	    	  var idx =  params.indexOf("max=");
	    	  MAX_FRIENDS = parseInt(params.substring(idx + "max=".length));
	    	  LOG ("MAX_FRIENDS = " + MAX_FRIENDS);
	      }
	  } catch (e) { }
	  
	  var MAP_DATA, CODES_TO_PEOPLE;
	  
	  function reset_map_data() {
		  MAP_DATA = [['Country', 'Popularity']];
		  CODES_TO_PEOPLE = {}; // code -> map (person -> 1) so that person's don't get repeated
	  }      
      
      function refresh_map() {
	       data_table = google.visualization.arrayToDataTable(MAP_DATA);
	       view = new google.visualization.DataView(data_table);
	       view.setColumns([0, 1, {
	           type: 'string',
	           role: 'tooltip',
	           calc: function (d, row) {
//	               var tooltip = d.getRowProperty(row, 'Country'); // 'row = ' + row;
	               var code = MAP_DATA[row+1][0];
	               var tooltip = join_keys(CODES_TO_PEOPLE[code], 5);
	        	   LOG ('row = ' + row + ' tooltip = ' + tooltip);
	        	   return tooltip;
	           }
	       }]);
	       
		  chart.draw(view, CHART_OPTS);
      }
      
      /** resp has to be an array of objects, each with a code field */
      function record_countries_for_friend(name, resp)
      {
		  LOG (name + ' has ' + resp.length + ' countries');
		  for (var i = 0; i < resp.length; i++)
		  {
			  if (resp[i])
			  {
				  var code = resp[i].code;
				  //alert(MAP_DATA);
				  if (typeof CODES_TO_PEOPLE[code] != 'undefined')
					  CODES_TO_PEOPLE[code][name] = 1; // existing country, just push this name (but bug: we're not updating tooltips... )
				  else
				  {
				   	  // new country
					  CODES_TO_PEOPLE[code] = {};
					  CODES_TO_PEOPLE[code][name] = 1;
					  MAP_DATA.push([code, 100]);
					  refresh_map();
					  $new = $('<span id="flag_' + code + '" style="display:none"><img height:13px" title="' + CODE_TO_DESCR[resp[i].code] + '" src="http://flagpedia.net/data/flags/mini/' + resp[i].code.toLowerCase() + '.png"/> ' + ' &nbsp;&nbsp; </span>');
					  $("#countries").append ($new);
					  $('#flag_' + code).fadeIn('slow'); // ease in nicely
				  }
			  }
		  }
      }
      
      /* friends is an array of objects {id:.., name:..}. initially called with just one id, {id:MY_ID, name:'?"}
       * user_details is an object with fields straight from FB */
      function done_for_users(friends, user_details) {
	          var json = JSON.stringify(user_details);
	    	  var names = $.map(friends, function(o) { return o.name; });
			  var ids = $.map(friends, function(o) { return o.id; });
    	      // record the data to recorder.jsp, it will return us a bunch of country code fields for each id
	          $.ajax ({
				  url: '/80friends/ajax/recorder.jsp',
	        	  type: 'POST',
	        	  dataType: 'json',
	        	  data: { my_id: MY_ID, my_name: MY_NAME, ids: ids, friendNames: names, body: json},
	        	  success: function(resp) {
	        		  // the resp is like {id: {... country data }, id2: {... }}
	        		  for (var i = 0; i < ids.length; i++)
	        			  record_countries_for_friend(names[i], resp[ids[i]]);
	        		  
	        		  // if my id, also pick up friends list
	        		  if (ids[0] == MY_ID) {
	        			  FRIENDS = user_details[MY_ID].friends.data;  
	        			  /*
	        			   * not clear that loc data for subscribees is actually accessible most of the time... e.g. Ariana Huffington's Greece does not show up
	        			  if (typeof user_details[MY_ID].subscribees !== 'undefined')
	        			  {
	        				  var subs = user_details[MY_ID].subscribees.data;
		        			  LOG('Adding ' + subs.length + ' subscribers to friends list');
	        				  for (var j = 0; j < subs.length; j++)
	        					  FRIENDS.push(subs[j]);
	        			  }
	        			   */
	        			  var message = 'Now processing data for ' + FRIENDS.length + ' friends';
	        			  LOG (message);
	        		  }

	        		  if (N_FRIENDS_COMPLETE >= MAX_FRIENDS || FRIENDS.length == 0) {
	        			  // we're done fetching
	        			  show_uncovered_countries();
	        			  return;
	        		  }
	        		  
	        		  // assemble friends for this fetch
	        		  var BATCH_SIZE = 20;
        			  var tmp = [];
	        		  for (var i = 0; i < BATCH_SIZE; i++) {	        			  
	        			  if (N_FRIENDS_COMPLETE >= MAX_FRIENDS || FRIENDS.length == 0)
	        				  break;
	        			  tmp.push(FRIENDS.shift());
	        			  N_FRIENDS_COMPLETE++; 
	        		  }
        		      fetch_users_details(tmp); 
	    	     }
	       	  });
      }
      
      var MY_ID = '?', MY_NAME = "?"; // we need to find me_real_id at some point, not just 'me'
  
      /* friends is an array if {id:.., name:..} objs */
      function fetch_users_details (friends) {
    	  var names = $.map(friends, function(o) { return o.name; });
    	  LOG ('fetching friends ' + names);   
    	  var ids = $.map(friends, function(o) { return o.id; });

    	  var html = '<div id="looking_up" style="display:none">';
    	  for (var i = 0; i < friends.length; i++)
    		  html += '<img src="http://graph.facebook.com/' + friends[i].id + '/picture" title="' + friends[i].name + '" style="height:20px"/> ';
    	  if (friends.length > 2)
    		  html += '&nbsp;<img src="images/spinner.gif" style="position:relative;bottom:3px;height:15px"/>';
    	  html += '</div>';
    	  $('#fb_status').html(html);
    	  $('#looking_up').fadeIn('slow');
    	  
    	  var me_fields = ['name', 'subscribees', 'friends', 'hometown', 'location']; // #checkins
    	  var other_fields = ['name', 'hometown', 'location']; // #checkins
    	  // fields to fetch: for me, friends + loc, for others, just loc
    	  var fields = (ids[0] == MY_ID ? me_fields : other_fields);

    	  // do the fetch... what about error handling?
    	  var url = '?ids=' + ids.join() + '&fields=' + fields.join();
    	  LOG ('fb api: ' + url);
    	  FB.api(url, function(response) { 
    		  done_for_users(friends, response);
    	  });
      }
  
    function populate_existing_info() {
		  $.ajax({url: '/80friends/ajax/getPersonInfo.jsp?id=' + MY_ID, 
				 type:'GET',
				 dataType:'json',
				 success: function(resp) {
					  var ownLocs = resp.ownLocs;
					  var tmp = new Array();
					  for (var i = 0; i < ownLocs.length; i++)
						  tmp.push({code: ownLocs[i]});
					  record_countries_for_friend(MY_NAME, tmp);
					  
					  var friendToLocations = resp.friendToLocations;
					  for (var friendId in friendToLocations) {
						  var friendName = resp.friendIdToName[friendId];
						  var friendLocs = (friendToLocations[friendId]);
						  // convert friendLocs into the format needed by record_countries_for_friend
						  var tmp = new Array();
						  for (var i = 0; i < friendLocs.length; i++)
							  tmp.push({code: friendLocs[i]});
						  record_countries_for_friend(friendName, tmp);
					  }
					  
					  show_uncovered_countries();
		  }
		  });
	  }
    
    function show_uncovered_countries()
    {
    	$('#refresh_icon').fadeIn();
    	$('#refresh_icon').click(populate_friends_anew);
    	
    	// we're all done, no more lookups
    	var n_countries = own_keys(CODES_TO_PEOPLE).length;
    	if (n_countries >= 2)
    		$('#fb_status').html('Congratulations, ' + MY_NAME + ', you have connections to ' + n_countries + ' countries.');
    	else
    		$('#fb_status').html('Uh, oh. Looks like you need more connections.');

    	$("#absent_countries").html('<br/><hr/><h1>No connections to:</h1>');
		LOG (ALL_CODES.length + ' countries');
		for (var i = 0; i < ALL_CODES.length; i++)
		{
			var code = ALL_CODES[i].code;
			if (typeof CODES_TO_PEOPLE[code] == 'undefined')
			{
				// no fadein effect here because there are many countries and they are all displayed rapidly
				$("#absent_countries").append ('<img style="height:13px" id="' + ALL_CODES[i].code + '" title="' + ALL_CODES[i].descr + '" src="http://flagpedia.net/data/flags/mini/' + ALL_CODES[i].code.toLowerCase() + '.png"/> ' + ' &nbsp;&nbsp; ');
			}
		}
		$('#match_button').fadeIn();
		$('#match_button').click(function() { return show_matches(); });
		$('#compare_button').fadeIn();
		$('#compare_button').click(function() { window.location = "leaderboard"; });

		$('#absent_countries img').click (function(e) { 
			var target = e.target; 
			$(target).next().html(''); // fade out spaces after this image too
			$(target).fadeOut();
		});
    }

    function show_matches() {
    	var $x = $('#absent_countries img');
    	var url = 'match.jsp?id=' + MY_ID;
    	for (var i = 0; i < $x.length; i++)
    		url += '&code=' + $($x[i]).attr('id');
    	window.location = url;
    }

    function populate_friends_anew() {
    	// wipe out stuff in case it already existed, and the user pressed refresh
    	$('#countries').html('');
    	
    	$('#absent_countries').html('');
    	$('#compare_button').hide();
    	$('#match_button').hide();
    	
    	reset_map_data();
    	refresh_map();

    	fetch_users_details([{id: MY_ID, name: 'me'}]); // this will also kick off fetching friends details

//    	fetch_user_details(MY_ID, 'me'); // this will also kick off fetching friends details
    }

    function onLogin() {
    	reset_map_data();
    	MY_ID = FB.getUserID(); // this can't be null
    	if (MY_ID == 0)
    		return; // login failed
    	
    	$('#map_button').fadeOut();

    	$.ajax (
    		{url:'/80friends/ajax/saveId.jsp?id=' + MY_ID,
        		type:'GET',
        		dataType: 'json',
        		success: function(resp) { } // don't do anything
    		});

    	// check if id exists				 
    	$.ajax (
    		{url:'/80friends/ajax/idExists.jsp?id=' + MY_ID,
    		type:'GET',
    		dataType: 'json',
    		success: function(resp) {
       			MY_NAME = resp.name;
       		    $('#top_right').html('<img src=\"http://graph.facebook.com/' + MY_ID + '/picture\"/>');
//    	    	$('#top_right').append('<br/>' + MY_NAME);
        		if (resp.id_exists)
        			populate_existing_info();
        		else
        			populate_friends_anew();
        	}
    		});
    } // end of login response
        
    function see_map_handler() {
    	FB.login(onLogin, 
    			{scope:'email,user_checkins,user_likes,user_hometown,friends_hometown,user_location,friends_location,user_work_history,friends_work_history,user_education_history,friends_education_history,user_activities,friends_activities,user_subscriptions,friends_subscriptions'});	       
    }
    
    window.fbAsyncInit = function() {
        FB.init({
      	  appId: ((window.location.hostname.indexOf('localhost') >= 0) ? '346227095454470' /* '345533228861202' */ : '427320467320919'), // first is test app on localhost, second for muse.stanford.edu
          //  auth_response: auth,
            status     : true, 
            cookie     : true,
            xfbml      : true,
            oauth      : true
          });
        doFBStuff();
    };
    
    function doFBStuff() {
    	// default ajax error processing
    	$(document).ajaxError (function() { $("#fb_status").html (' (<span style="color:red">Ah, an error occured. Sorry!</span>)'); });
    	$.ajax ({   url: '/80friends/ajax/getAllCodes.jsp',
    		type: 'GET',
    		dataType:'json',
    		success: function(resp) { 
    			ALL_CODES = resp; 
    			for (var i = 0; i < ALL_CODES.length; i++) 
    				CODE_TO_DESCR[ALL_CODES[i].code] = ALL_CODES[i].descr;
    		}
    		});
    	
    	FB.getLoginStatus(function(response) {
    		  if (response.status === 'connected') {
    		    // the user is logged in and has authenticated your
    		    // app, and response.authResponse supplies
    		    // the user's ID, a valid access token, a signed
    		    // request, and the time the access token 
    		    // and signed request each expire
    			onLogin();
    		  } else {
    		    	$('#map_button').fadeIn();
    		  }
    		  /*
    		  } else if (response.status === 'not_authorized') {
    		    // the user is logged in to Facebook, 
    		    // but has not authenticated your app
    		  }
    		  */
    	});
    };