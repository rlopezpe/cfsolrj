import cc.rolando.solr.*;

/**
* @hint Allows the indexing of large amounts of data into Solr Documents
* @accessors true
* @author Rolando Lopez
*/


component {

	property name="dsn" type="string" getter="true" setter="false";
	property name="recordsPerIndex" type="numeric" getter="true" setter="false";
	property name="javaTypeValidator" type="cc.rolando.validation.JavaTypeValidator" getter="true" setter="false";
	property name="config" type="cc.rolando.config.Config" getter="true" setter="false";
	property name="indexDao" type="cc.rolando.solr.utils.I_IndexDAO" getter="true" setter="false";
		/* Java Types */
	property name="solrServer"		type="any" hint="javaType:org.apache.solr.client.solrj.impl.CommonsHttpSolrServer" 	getter="true" setter="false";
	property name="httpStatus" 		type="any" hint="javaType:org.apache.commons.httpclient.HttpStatus" 				getter="true" setter="false";
	property name="clientUtils" 	type="any" hint="javaType:org.apache.solr.client.solrj.util.ClientUtils"			getter="true" setter="false";
	property name="solrUtils" 		type="any" hint="javaType:cc.rolando.utils.SolrUtils" 								getter="true" setter="false";

		/* Constructor */

	public cc.rolando.solr.utils.IndexManager function init(numeric recordsPerIndex=10000
															, required string dsn
															, required string solrServiceUrl
															, required any httpStatus
															, required cc.rolando.validation.JavaTypeValidator javaTypeValidator
															, required cc.rolando.Config config
															, required any solrUtils
															, required I_IndexDAO indexDao
															){
		variables.javaTypeValidator 	= arguments.javaTypeValidator;
		variables.javaTypeValidator.validate(arguments.solrUtils, "cc.rolando.utils.SolrUtils");
		variables.dsn = arguments.dsn;
		variables.solrServiceUrl = arguments.solrServiceUrl;
		variables.httpStatus 	= arguments.httpStatus;
		variables.config 		= arguments.config;
		variables.solrUtils 	= arguments.solrUtils;
		variables.solrServer 	= server.cfSolrJJavaLoader.create("org.apache.solr.client.solrj.impl.CommonsHttpSolrServer").init(solrServiceUrl);
		variables.indexDao 		= arguments.indexDao;
		return this;
	}

	public void function index(boolean replaceExistent=true ){
		var rs = getIndexDao().getData();

			//extend request timeout
		setting requesttimeout="10000";

		if(rs.recordCount){

				// get the Solr service instance
			var solr = getSolrServer();
				//initialize the array to hold the Solr Documents
			var aDocuments = [];
			var startTime = getTickCount(); // start counter

			for(var row in local.rs){
					// initialize the holder of current document as temp var
				var tmpDocument	=server.cfSolrJJavaLoader.create("org.apache.solr.common.SolrInputDocument");
				var arrays={"actors"=[]};

					//@javaMethod 
				local.tmpDocument.addField("uid",javaCast("int",row.film_id));
				local.tmpDocument.addField("key",javaCast("int",row.film_id));
				local.tmpDocument.addField("summary",row.description);
				local.tmpDocument.addField("title",row.title);
				// local.tmpDocument.addField("sort_title",sort_title);
				local.tmpDocument.addField("release_year", javaCast('int',row.release_year) );
				local.tmpDocument.addField("rental_duration", javaCast('int',row.rental_duration) );
				local.tmpDocument.addField("rental_rate", javaCast('float',row.rental_rate) );
				local.tmpDocument.addField("replacement_cost", javaCast('float',row.replacement_cost) );
				local.tmpDocument.addField("last_update", row.last_update );

				local.tmpDocument.addField("contents",row.description);
				local.tmpDocument.addField("contents",row.title);
				local.tmpDocument.addField("contents",row.release_year);

					// append the current document to the Array of Documents
				arrayAppend(local.aDocuments, local.tmpDocument);
			}

				//add all documents to the Solr Collection
			local.solr.add(local.aDocuments);
			local.solr.commit(); // commit the changes
			local.endTime = getTickCount();

			writeLog(text:"Solr Indexing completed in #local.endTime-local.startTime# ms or #(local.endTime-local.startTime)/1000# s"
						,type:"information"
						,file:"cfSolrJ_Index");

				//update isIndex field in DB.


		}

	}


	public any function search(String criteria
								, numeric searchType
								, String returnFormat
								, boolean highlight=false
								){


		switch(arguments.returnFormat){
			case 'query':
			case 'json':
			case 'struct':
				local.wt="json";
				break;
			case 'xml':
				local.wt="xml";
				break;
			case 'javabin':
				local.wt="javabin";
				break;
			default:
				local.wt="json";
		}
		switch(arguments.searchType){
			case 0:
				arguments.criteria = "+" & listChangeDelims(arguments.criteria," +"," ");
			break;
			case 1:
				arguments.criteria = '+(' & arguments.criteria & ')';
			break;
			case 3:
			default:
				arguments.criteria = 'contents:"' & arguments.criteria & '" ' & 'title:"' & arguments.criteria & '"' ;
		}       

		local.startTime = getTickCount();
		local.httpService = new http(url:variables.solrServiceUrl & "/select");
		local.httpService.setMethod("post");
		local.httpService.addParam(type:"formfield", name:"q", value:arguments.criteria);
		local.httpService.addParam(type:"formfield", name:"wt", value:"#local.wt#");
		local.httpService.addParam(type:"formfield", name:"hl", value:arguments.highlight);
		local.httpService.addParam(type:"formfield", name:"hl.fl", value:"title,summary,contents");
		/* local.httpService.addParam(type:"formfield", name:"fl", value:arguments.fields);
		local.httpService.addParam(type:"formfield", name:"start", value:arguments.startrow);
		local.httpService.addParam(type:"formfield", name:"rows", value:arguments.maxrows);
		local.httpService.addParam(type:"formfield", name:"sort", value:arguments.sort);
 		*/
 		local.httpResponse = local.httpService.send().getPrefix();
 		local.endTime = getTickCount();

 		if(val(local.httpResponse.statusCode) == variables.httpStatus.SC_OK){
			local.searchResults["struct"] = deserializeJSON(local.httpResponse.Filecontent);

			if(arguments.highlight)
				applyHighlights(local.searchResults.struct);
 			
			switch(arguments.returnFormat){
				case 'json':
				case 'xml':
				case 'javabin':
					return local.httpResponse.Filecontent;
					break;
				case 'query':
					return  arrayOfStructuresToQuery(local.searchResults.struct.response.docs);
					break;
				case 'struct':
					return local.searchResults.struct;
					break;
			}

			writeLog(text:"Solr search in #local.endTime-local.startTime# ms or #(local.endTime-local.startTime)/1000# s and found #local.searchResults.struct.response.numfound# records"
					,type:"information",file:"heroSearch");
		}else{
			throw(message:"Error contacting Solr service via http. Response code #local.httpResponse.statusCode# ");
		}

 		return local.httpResponse.fileContent;

	}

		private void function applyHighlights(required struct solrResults){
			if(structKeyExists(arguments.solrResults,"highlighting")){
				
				for(ixDoc in arguments.solrResults.response.docs){
					if( structKeyExists	(arguments.solrResults.highlighting, ixDoc.uid)
						&& !structIsEmpty(arguments.solrResults.highlighting[ixDoc.uid])
						){
						ixDoc.summary = arguments.solrResults.highlighting[ixDoc.uid].summary[1];
					}

				}
			}
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

		private query function queryChangeColumnName(required query Query, required String columnName, required String newColumnName){
				/* Get the list of column names. We have to get this
				from the query itself as the "ColdFusion" query may have had an updated column list. */
			LOCAL.columns = ARGUMENTS.Query.GetColumnNames();
	 
				/* Convert to a list so we can find the column name.
				This version of the array does not have indexOf type functionality we can use. */
			LOCAL.ColumnList = ArrayToList(
				LOCAL.columns
				);
	 
				// Get the index of the column name.
			LOCAL.ColumnIndex = ListFindNoCase(LOCAL.ColumnList, ARGUMENTS.ColumnName);
	 
				// Make sure we have found a column.
			if (LOCAL.ColumnIndex){
	 
					/* Update the column name. We have to create our own array based on the list since we
					cannot directly update the array passed back from the query object. */
				LOCAL.columns = ListToArray(LOCAL.ColumnList);
				LOCAL.columns[ LOCAL.ColumnIndex ] = ARGUMENTS.NewColumnName;
	 
					// Set the column names.
				ARGUMENTS.Query.SetColumnNames(LOCAL.columns);
			}
				// Return the query reference.
			return( ARGUMENTS.Query );
		}



}



 /* <field name="title"        type="text_ws" indexed="true"  stored="true" required="false" />
    <field name="author"       type="text_ws" indexed="true"  stored="true" required="false" />
    <field name="description"  type="string" indexed="true"  stored="true" required="false" />
    <field name="release_year" type="sint"   indexed="true" stored="true" required="false"  />  
    <field name="keywords"     type="text_ws" indexed="true"  stored="true" required="false" />
    <field name="uid"          type="string" indexed="true"  stored="true" required="false" />
    <field name="language_id"          type="sint" indexed="true"  stored="true" required="false" />
    <field name="original_language_id"          type="sint" indexed="true"  stored="true" required="false" />
    <field name="rental_duration"          type="sint" indexed="true"  stored="true" required="false" />
    <field name="rental_rate"          type="sfloat" indexed="true"  stored="true" required="false" />
    <field name="replacement_cost"          type="sfloat" indexed="true"  stored="true" required="false" />
    <field name="last_update"          type="date" indexed="true"  stored="true" required="false" />
    <field name="uid"	        type="string" indexed="true"  stored="true" required="false" /> */