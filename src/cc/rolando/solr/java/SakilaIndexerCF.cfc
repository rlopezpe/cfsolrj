	/**
	* @hint 'This class is designed to be consumed by Java using the <a href="http://markmandel.github.io/JavaLoader/api/cfcdynamicproxy/">CFCDynamicProxy</a><br /> '
	* @author "Rolando Lopez"
	*/
component {

	public cc.rolando.solr.java.SakilaIndexerCF function init(){
		return this;
	}
		/** 
		* @Override
		*/ 
	public any function populateDocument(required query rs){
		var releaseYear = javaCast("null", ""); //java.util.Date
		// var Calendar = createObject("java","java.util.Calendar"); // Refernce to Class
		// var cal = Calendar.getInstance(); // instance of java.util.Calendar
			/* create a reference to the System.out static field
				The equivalent of 'import static java.lang.System.out;' in Java
			 */
		var out = createObject("java", "java.lang.System").out;
		var StringClass = createObject("java","java.lang.String"); //reference to String Class

			/* attempt to parse releaseyear date */
		
		var year = trim(rs.release_year); // int
		
		var inDoc = SERVER.cfSolrJJavaLoader.create("org.apache.solr.common.SolrInputDocument").init(); // SolrInputDocument
		
			// TODO change this code to throw an exception
		if(len(trim(rs.film_id)) == 0 ){
			out.println("Missing ID");
			inDoc.addField("id",Math.random()); // remove this line
		}else{
			// out.println("film_id: " & StringClass.valueOf( rs.getInt("film_id") ));
		}
		
		var id = rs.film_id;
		inDoc.addField("id",id);
		inDoc.addField("key",id);
		inDoc.addField("summary",rs.description);
		inDoc.addField("title", rs.title);
		inDoc.addField("release_year", javaCast("int",year));
		inDoc.addField("rental_duration", javaCast("int",rs.rental_duration) );
		inDoc.addField("rental_rate", javaCast("float",rs.rental_rate) );
		inDoc.addField("replacement_cost", javaCast("float", rs.replacement_cost) );
		inDoc.addField("last_update", createObject("java","java.sql.Timestamp").init(javaCast("long",rs.last_update)) );
		
		return inDoc;
	}

}	
	