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
	              appId      : '427320467320919',
	            //  auth_response: auth,
	              status     : true, 
	              cookie     : true,
	              xfbml      : true,
	              oauth      : true,
	            });
      };
      
      var fields = ['friends', 'locations']; // #checkins
      var N_PEOPLE = 0; // tmp throttle
      var map_data = [['Country', 'Popularity']];
      var codes_to_people = {}; // code -> map (person -> 1) so that person's don't get repeated
      
      function done_for_user(id, name, user_details) {
	          var json = JSON.stringify(user_details);
	         // LOG(json);  	          
    	      LOG('friendName: ' +  name);
	          $.ajax (
			  {
				  url: '/80friends/ajax/recorder.jsp',
	        	  type: 'POST',
	        	  data: { friendName: name, body: json},
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
	        					  $("#countries").append (resp[i].descr + '&nbsp;&nbsp; ');
	        				  }
	        			  }
	        		  }

	        		  if (id == 'me') {
	        			  friends_data = user_details.friends.data;  
	        			  var message = '<br/>Now processing data for ' + friends_data.length + ' friends';
	        			  LOG (message);
	        			  $("#fb_status").append(message);
	        		  }

	        		  if (friends_data.length > 0) {
	        			  // fire off the next lookup
	        			  var friend = friends_data.shift();
	        			  if (N_PEOPLE < 1000) {
	        				  process_user(friend.id, friend.name); 
	        				  N_PEOPLE++;
	        			  }
	        		  }
	    	         else
		  	  	         $('#fb_status').html('Congratulations, you have friends from ' + Object.keys(codes_to_people).length + ' countries');
	    	     },
	        	  error: function() { $("#fb_status").html (' (<span style="color:red">Ah, an error occured. Sorry!</span>)'); }
	       	  });
      }
      
      function process_user (id, name) {
			  LOG ('fetching id ' + id + ', ' + name);
	          $("#fb_status").html('Looking up ' + name);

			  var user = new Object();
	          FB.api('/' + id, function(response) { user.about = response; });
	          var  nReqs = fields.length;
	          var nCompletedReqs = 0;
	          for (var i = 0; i < fields.length; i++) {
				var field = fields[i];
				LOG ('field ' + field);
	            FB.api('/' + id + '/' + field, function(f) { return function(response) { 
	            	nCompletedReqs++;
	            	LOG ('received field = ' + f); 

	            	user[f] = response; 
	            	if (nCompletedReqs == nReqs) 
	            		done_for_user(id, name, user); 
	            	};
	            }(field));
			}
		}
      
		function doFBStuff() {
	        FB.login(function(response) {
				process_user ('me', 'me');
	        },
			{scope:'user_checkins,user_likes,user_hometown,friends_hometown,user_location,friends_location,user_work_history,friends_work_history,user_education_history,friends_education_history,user_activities,friends_activities'});	       
      };
      
