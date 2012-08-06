<%@page language="java" contentType="application/json; charset=UTF-8"%>
<%@page language="java" import="java.io.*"%>
<%@page language="java" import="java.util.*"%>
<%@page language="java" import="java.math.*"%>
<%@page language="java" import="com.google.gson.*"%>
<%@page language="java" import="org.json.*"%>
<%@page language="java" import="org.apache.batik.apps.*"%>
<%@page language="java" import="edu.stanford.eightyfriends.*"%>
<% 	

---- on js side:
	
function invite_button_clicked() {
	 var chartArea = $('#map')[0].getElementsByTagName('iframe')[0].contentDocument.getElementById('chartArea');
	 var svg = chartArea.innerHTML;
	 $.ajax({url:'ajax/toImage.jsp', 
		 type:'POST',
		 dataType:'json',
		 data: {svg: svg},
		 success: function(resp) { 
			 
			 ---
			 
		 }
	String my_id = (String) session.getAttribute("my_id");

	String svg = request.getParameter("svg");
	String data = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n" +
	"<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\"\n" +
    "\"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\" >\n";
    
    data += "\n";
    data += svg;
	
	String rel_url = "images/globe.png";
	try {
		String baseDir = request.getServletContext().getRealPath("/").toString();
		String imageDir = baseDir + File.separator + "uimages";
		new File(imageDir).mkdirs();
		String prefix = String.format ("%08x", new Random(System.currentTimeMillis()).nextInt());
		String svg_file = imageDir + File.separatorChar + prefix + ".svg";
		JSPHelper.log ("saving svg for " + my_id + " in " + svg_file);
				
		PrintWriter pw = new PrintWriter(new FileOutputStream(svg_file));
		pw.println(data);
		pw.close();
		
		String args[] = new String[]{"-scriptSecurityOff", svg_file};
		org.apache.batik.apps.rasterizer.Main.main(args);
		rel_url = "uimages/" + prefix + ".png";
	} catch (Exception e) { 	}
	
	String base_url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
	JSONObject o = new JSONObject().put("url", base_url + "/" + rel_url);
	out.println(o.toString());
%>