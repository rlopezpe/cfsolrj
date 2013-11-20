	/**
	* @hint 'This class is designed to be consumed by Java using the <a href="http://markmandel.github.io/JavaLoader/api/cfcdynamicproxy/">CFCDynamicProxy</a><br /> '
	* @author "Rolando Lopez"
	*/
component {

	public cc.rolando.solr.java.SakilaIndexer function init(){
		return this;
	}
		/** 
		* @Override
		*/ 
	public any function populateDocument(required any rs){
		setting requestTimeout="10000";
		
		var releaseYear = javaCast("null", ""); //java.util.Date
		var Calendar = createObject("java","java.util.Calendar"); // Refernce to Class
		var cal = Calendar.getInstance(); // instance of java.util.Calendar
			/* create a reference to the System.out static field
				The equivalent of 'import static java.lang.System.out;' in Java
			 */
		var out = createObject("java", "java.lang.System").out;
		var StringClass = createObject("java","java.lang.String"); //reference to String Class

			/* attempt to parse releaseyear date */
		try {
			var releaseYearOnly = rs.getDate("release_year").toString();
			releaseYear = createObject("java", "java.text.SimpleDateFormat").init("MM/dd/yyyy").parse("01/01/" & releaseYearOnly);
		} catch (java.text.ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		cal.setTime(releaseYear);
		var year = cal.get(Calendar.YEAR); // int
		
		var inDoc = SERVER.cfSolrJJavaLoader.create("org.apache.solr.common.SolrInputDocument").init(); // SolrInputDocument
		
			// TODO change this code to throw an exception
		if(rs.getString("film_id") == javaCast("null", "")){
			out.println("Missing ID");
			inDoc.addField("id",Math.random());
		}else{
			// out.println("film_id: " & StringClass.valueOf( rs.getInt("film_id") ));
		}
		
		var id = StringClass.valueOf(rs.getInt("film_id")); //java.lang.String
		inDoc.addField("id",id);
		inDoc.addField("key",id);
		inDoc.addField("summary",rs.getString("description"));
		inDoc.addField("title", rs.getString("title"));
		inDoc.addField("release_year", year);
		inDoc.addField("rental_duration", rs.getInt("rental_duration") );
		inDoc.addField("rental_rate", rs.getFloat("rental_rate"));
		inDoc.addField("replacement_cost", rs.getFloat("replacement_cost"));
		inDoc.addField("last_update", rs.getTimestamp("last_update") );
		
		var qFilmActors = application.salikaDao.getFilmActors(local.id);

			// add actors
		for( var actor in qFilmActors){
			// out.println("Adding actor: " & actor.full_name);
			inDoc.addField("actors",actor.full_name);
			inDoc.addField("actors_id",javaCast("int",actor.actor_id));
		}


		return inDoc;
	}

}	
	