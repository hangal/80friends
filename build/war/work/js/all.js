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
    }

    function join_keys(o, max) {
    	// ellipsize beyond max
    	var keys = Object.keys(o);
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
    var friends_data; // list of friend ids and names

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
  	
      window.fbAsyncInit = function() {
	          FB.init({
	        	  appId: ((window.location.hostname.indexOf('localhost') >= 0) ? '345533228861202' : '427320467320919'), // first is test app on localhost, second for muse.stanford.edu
	            //  auth_response: auth,
	              status     : true, 
	              cookie     : true,
	              xfbml      : true,
	              oauth      : true,
	            });
      };
      
      var me_fields = ['friends', 'locations']; // #checkins
      var other_fields = ['locations']; // #checkins
      var N_PEOPLE = 0; // tmp throttle
      var MAX_PEOPLE = 10000;
      try {
    	  // see if a max= param is specified, should be at the end. 
    	  // fragile, under hackathon time pressure!
    	  var params = window.location.search;
	      if (params && params.indexOf("max=") >= 0)
	      {
	    	  var idx =  params.indexOf("max=");
	    	  MAX_PEOPLE = parseInt(params.substring(idx + "max=".length));
	    	  LOG ("MAX_PEOPLE = " + MAX_PEOPLE);
	      }
      } catch (e) { }
      
      var map_data = [['Country', 'Popularity']];
      var codes_to_people = {}; // code -> map (person -> 1) so that person's don't get repeated
      
      function done_for_user(me_real_id, my_name, id, name, user_details) {
	          var json = JSON.stringify(user_details);
	         // LOG(json);  	          
    	      LOG('friendName: ' +  name);
	          $.ajax (
			  {
				  url: '/80friends/ajax/recorder.jsp',
	        	  type: 'POST',
	        	  data: { my_id: me_real_id, my_name: my_name, id: id, friendName: name, body: json},
	        	  success: function(response) { 
	        		  response = trim(response);
	        		  try { var resp = eval('(' + response + ')'); countries = resp.locations;}
	        		  catch (e) { LOG('error in evaluating muse response'); return; }
	        		  LOG (name + ' : ' + resp.length + ' countries');
	        		  for (var i = 0; i < resp.length; i++)
	        		  {
	        			  if (resp[i])
	        			  {
	        				  var code = resp[i].code;
	        				  //alert(map_data);
	        				  if (typeof codes_to_people[code] != 'undefined')
	        					  codes_to_people[code][name] = 1; // existing country, just push this name
	        				  else
	        				  {
	        					  // new country
	        					  codes_to_people[code] = {};
	        					  codes_to_people[code][name] = 1;
		        				  map_data.push([code, 100]);
		        				  
		        			       data_table = google.visualization.arrayToDataTable(map_data);
		        			       
		        			       view = new google.visualization.DataView(data_table);
		        			       view.setColumns([0, 1, {
		        			           type: 'string',
		        			           role: 'tooltip',
		        			           calc: function (d, row) {
//		        			               var tooltip = d.getRowProperty(row, 'Country'); // 'row = ' + row;
		        			               var code = map_data[row+1][0];
		        			               var tooltip = join_keys(codes_to_people[code], 5);
		        			        	   LOG ('row = ' + row + ' tooltip = ' + tooltip);
		        			        	   return tooltip;
		        			           }
		        			       }]);
		        			       
	        					  chart.draw(view, CHART_OPTS);
	        					  $new = $('<span style="display:none"><img height:13px" title="' + resp[i].descr + '" src="http://flagpedia.net/data/flags/mini/' + resp[i].code.toLowerCase() + '.png"/> ' + ' &nbsp;&nbsp; </span>');
	        					  $("#countries").append ($new);
	        					  $new.fadeIn('slow'); // ease in nicely
	        				  }
	        			  }
	        		  }

	        		  if (id == me_real_id) {
	        			  friends_data = user_details.friends.data;  
	        			  var message = '<br/>Now processing data for ' + friends_data.length + ' friends';
	        			  LOG (message);
	        			  $("#fb_status").append(message);
	        		  }

	        		  if (friends_data.length > 0 && N_PEOPLE < MAX_PEOPLE) {
	        			  // fire off the next lookup
	        			  var friend = friends_data.shift();
        				  process_user(friend.id, friend.name); 
        				  N_PEOPLE++;
	        		  }
	    	         else {
	    	        	 var n_countries = Object.keys(codes_to_people).length;
	    	        	 if (n_countries >= 2)
	    	        		 $('#fb_status').html('Congratulations, you have connections to ' + n_countries + ' countries.');
	    	        	 else
	    	        		 $('#fb_status').html('Uh, oh. Looks like you need more friends.');
	    	        	 show_uncovered_countries(me_real_id);
	    	         }
	    	     },
	        	  error: function() { $("#fb_status").html (' (<span style="color:red">Ah, an error occured. Sorry!</span>)'); }
	       	  });
      }
      
      var me_real_id = '?', my_name = "?"; // we need to find me_real_id at some point, not just 'me'
      
      function show_uncovered_countries(id)
      {
    	  $('#map_button').css('background-color', 'gray');
    	  $.ajax (
    			  {
    				  url: '/80friends/ajax/getAllCodes.jsp',
    	        	  type: 'GET',
    	        	  success: function(response) { 
    	            	  $("#absent_countries").append('<br/><hr/><h1>We&quot;ll look for friends in</h1>')
    	        		  response = trim(response);
    	        		  try { var resp = eval('(' + response + ')'); }
    	        		  catch (e) { LOG('error in evaluating muse response'); return; }
    	        		  LOG (resp.length + ' countries');
    	        		  for (var i = 0; i < resp.length; i++)
    	        		  {
	        				  var code = resp[i].code;
	        				  if (typeof codes_to_people[code] == 'undefined')
	        				  {
	        					  LOG ('dont have ' + resp[i]);
	        					  // no fadein effect here because there are many countries and they are all displayed rapidly
	        					  $("#absent_countries").append ('<img style="height:13px" id="' + resp[i].code + '" title="' + resp[i].descr + '" src="http://flagpedia.net/data/flags/mini/' + resp[i].code.toLowerCase() + '.png"/> ' + ' &nbsp;&nbsp; ');
	        				  }
    	        		  }
    					  $('#match_button').fadeIn();
    					  $('#match_button').click(function() { return mark_friends_needed(id); });
    					  $('#absent_countries img').click (function(e) { 
    						  var target = e.target; 
    						  $(target).next().html(''); // fade out spaces after this image too
    						  $(target).fadeOut();
    					});
    	    	     },
    	        	  error: function() { $("#fb_status").html (' (<span style="color:red">Ah, an error occured. Sorry!</span>)'); }
    	       	  });
      }
      
      function mark_friends_needed(id) {
    	  var $x = $('#absent_countries img');
    	  var url = 'match.jsp?id='+id;
    	  for (var i = 0; i < $x.length; i++)
    		  url += '&code=' + $($x[i]).attr('id');
    	  window.location = url;
    	  /*
    	  LOG ('url = ' + url);
    	  $.ajax (
    			  {
    				  url: url,
    	        	  type: 'GET',
    	        	  success: function(response) { 
    	        		  alert ('Thanks for signing up!');
    	        		  $('#match_button').css('background-color', 'gray'); // gray it out so people don't press it again and again
    	    	     },
    	        	  error: function() { $("#fb_status").html (' (<span style="color:red">Ah, an error occured. Sorry!</span>)'); }
    	       	  });
    	       	  */
      }
      
      function process_user (id, name) {
			  LOG ('fetching id ' + id + ', ' + name);
	          $("#fb_status").html('Looking up ' + name + "...");

			  var user = new Object();
	          var nCompletedReqs = 0;
	          var fields = (id == 'me' ? me_fields : other_fields);
	          var  nReqs = fields.length + 1; // +1 for the /<id> call
	      	  FB.api('/' + id, function(response) { 
	        	  user.about = response;
	        	  if (id == 'me') {
	        		  me_real_id = id = user.about.id; // this can't be null
	        		  my_name = user.about.name; // this can't be null
	        	  }
	        	  nCompletedReqs++; 
	        	  if (nCompletedReqs == nReqs) 
	        		  done_for_user(me_real_id, my_name, id, name, user); 
          	  });
	      	  
	          for (var i = 0; i < fields.length; i++) {
				var field = fields[i];
				LOG ('field ' + field);
	            FB.api('/' + id + '/' + field, function(f) { return function(response) { 
	            	nCompletedReqs++;
	            	user[f] = response; 
	            	if (nCompletedReqs == nReqs) 
	            		done_for_user(me_real_id, my_name, id, name, user); 
	            	};
	            }(field));
			}
		}
      
		function doFBStuff() {
	        FB.login(function(response) {
				process_user ('me', 'me');
	        },
			{scope:'email,user_checkins,user_likes,user_hometown,friends_hometown,user_location,friends_location,user_work_history,friends_work_history,user_education_history,friends_education_history,user_activities,friends_activities'});	       
      };
      
