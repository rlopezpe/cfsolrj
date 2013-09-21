import cc.rolando.solr.*;

/**
* @hint Basic example of leveraging the SolrJ API with ColdFusion
* @accessors true
* @author Rolando Lopez
*/

component {

	property name="solrServer" type="any" hint="javaType:org.apache.solr.client.solrj.impl.CommonsHttpSolrServer" getter="true" setter="false";


		// constructor
	public cc.rolando.solr.utils.SimpleIndex function init(){

		variables.collectionUrl = "http://localhost:8985/solr/salika_simple";
			// create an instance of SolrServer by passing URL of collection
		variables.solrServer = createObject("java", "org.apache.solr.client.solrj.impl.CommonsHttpSolrServer").init( variables.collectionUrl );
			// writeDump(getSolrServer());
			 // abort; 

		return this;
	}

		/* @hint "indexes data from the query in a collection" */
	public void function index(){

					//extend request timeout
			setting requesttimeout="10000";


			var salikaDAO 	= new cc.rolando.solr.utils.SalikaIndexDAO(); /* instantiate DAO */
				// get data
			var qFilms		= local.salikaDAO.getData(); /* get query of films data */
			
				 // writeDump(var:local.qFilms, top:5);
				  // abort;
			if( qFilms.recordCount ){

				var aDocuments 	= []; /* Array to place solr documents */
				var solr 		= variables.solrServer; // make a pointer to the variables.solrServer

					// create instance of SolarInputDocument where data from a query row will be placed in
					var startTime = getTickCount();
				for( ixFilm in qFilms ){
					
					local.tmpDocument = createObject("java", "org.apache.solr.common.SolrInputDocument").init();
					 // writeDump(local.tmpDocument);
// abort;
						//@javaMethod 
					local.tmpDocument.addField("uid",javaCast("int",ixFilm.film_id));
					local.tmpDocument.addField("key",javaCast("int",ixFilm.film_id));
					local.tmpDocument.addField("summary",ixFilm.description);
					local.tmpDocument.addField("title",ixFilm.title);
					local.tmpDocument.addField("release_year", javaCast('int',dateFormat(ixFilm.release_year,"yyyy")) );
						// writeDump(local.tmpDocument);
// abort;
						// add current document to the array of docs
					arrayAppend(local.aDocuments, local.tmpDocument);

					// writeDump(local.aDocuments);

				}
					// add array of solr documents to the solr collection
				local.solr.add(local.aDocuments);
				local.solr.commit(); /* commit the changes */


					var endTime = getTickCount();
					writeDump("<br /> Films indexed in " & (local.endTime - local.startTime) & " ms ");
					abort;
				}
	}

	public query function search(required String criteria, numeric startRow=0, numeric maxRows=20, string sort="score desc"){

		local.httpService = new http(url:variables.collectionUrl & "/select");
		local.httpService.setMethod("post");

		local.httpService.addParam(type:"formfield", name:"q", value:arguments.criteria);
		local.httpService.addParam(type:"formfield", name:"wt", value:"json");
		local.httpService.addParam(type:"formfield", name:"start", value:arguments.startrow);
		local.httpService.addParam(type:"formfield", name:"rows", value:arguments.maxrows);
		local.httpService.addParam(type:"formfield", name:"sort", value:arguments.sort);
		/* local.httpService.addParam(type:"formfield", name:"hl", value:arguments.highlight);
		local.httpService.addParam(type:"formfield", name:"hl.fl", value:"title,summary,actors"); 
 		*/
 			local.startTime = getTickCount();
 		local.httpResponse = local.httpService.send().getPrefix();
 			writeDump(var:"Search performed in: " & (getTickCount() - local.startTime) & " ms", output:"console"); // output to console
 			/* writeDump(local.httpResponse);
 			abort; */
 		if(left(local.httpResponse.statusCode,3) == 200){
 				local.startTime = getTickCount();

			local.searchResults.struct = deserializeJSON(local.httpResponse.Filecontent);
 			local.endRow	= arguments.startrow+arguments.maxrows-1;
			if(local.endRow > local.searchResults.struct.response.numfound){
				local.endRow = local.searchResults.struct.response.numfound;
			} 
 			local.extraColumns = {"total"=local.searchResults.struct.response.numfound,"startrow"=arguments.startrow+1,"endrow"=local.endRow+1};
 			/* writeDump(var:local.searchResults.struct.response.docs);
 			abort; */
 			var qReturn = arrayOfStructuresToQuery( local.searchResults.struct.response.docs, [], local.extraColumns );
 		}else{
 			throw("Error performing solr search. Status code " & local.httpResponse.statusCode);
 		}
 			var endTime = getTickCount();
 			writeDump(var:"Data transformed to query in: " & (local.endTime - local.startTime) & " ms", output:"console");
 		return local.qReturn;
	}






		/**
		 * Converts an array of structures to a CF Query Object.
		 * 6-19-02: Minor revision by Rob Brooks-Bilson (rbils@amkor.com)
		 * 
		 * Update to handle empty array passed in. Mod by Nathan Dintenfass. Also no longer using list func.
		 * Update By Rolando Lopez - Customized to accept defaultColumns paramenter array and exctraColumsCell struct. 
		 * 
		 * @param Array      The array of structures to be converted to a query object.  Assumes each array element contains structure with same  (Required)
		 * @return Returns a query object. 
		 * @author David Crawford (rbils@amkor.comdcrawford@acteksoft.com) customized by Rolando Lopez
		 * @version 3, 2012
		 */
		public query function arrayOfStructuresToQuery(required array theArray, array defaultColumns=[], struct extraColumnsCells){
		    var i=0;
		    var j=0;

		    try
            {
			    var totalRecords = arrayLen(arguments.theArray);

		    	//get the column names into an array =   
			    	var colNames = (arrayLen(theArray) ? structKeyArray(theArray[1]) : [] );

			   	for(var ixCol in arguments.defaultColumns){
			   		if(!arrayContains(local.colNames,ixCol))
			   			arrayAppend(local.colNames,ixCol);
			   	}
			   	
			    if(structKeyExists(arguments,"extraColumnsCells")){
			    	local.extraColNames = structKeyArray(arguments.extraColumnsCells);
			    	colNames.addAll(local.extraColNames);
			    }
			    	//build the query based on the colNames
			    var theQuery = queryNew(arrayToList(colNames));

			    	//if there's nothing in the array, return the empty query
			    if(!arrayLen(theArray))
			        return theQuery;
	
			    	//add the right number of rows to the query
			    queryAddRow(theQuery, arrayLen(theArray));
			   	 //for each element in the array, loop through the columns, populating the query
			    for(i=1; i LTE arrayLen(theArray); i=i+1){
			        for(j=1; j LTE arrayLen(colNames); j=j+1){
			        	if( structKeyExists(local, "extraColNames") && arrayFindNoCase(local.extraColNames,colNames[j])){
			        		local.cellValue = arguments.extraColumnsCells[colNames[j]];
			        	}else if(structKeyExists(theArray[i],colNames[j])){
			        		local.cellValue = theArray[i][colNames[j]];
			        	}else if(colNames[j] == "rownumber"){
			        		local.cellValue = j;
			        	}else
			        		local.cellValue = "";

			        	if(!isSimpleValue(local.cellValue)){
			        		if(isArray(local.cellValue))
			        			local.cellValue = arrayToList(local.cellValue,"|");
			        		else {
			        			local.cellValue = local.cellValue.toString();
			        		}
			        	}
			            	querySetCell(theQuery, colNames[j], local.cellValue, i);
			        }
			    }
            }
            catch(Any e)
            {
				rethrow;
            }
		    return theQuery;
		}


}