<cfscript>
	import cc.rolando.solr.*;
	/**
	* @author R.Lopez
	* @description A simple MVC controller
	*/
	

	switch(mvc.event){
		case "index":
			
			sakilaIndexer = new cc.rolando.solr.java.SakilaIndexer();
			// writeDump(sakilaIndexer);
			sakilaDAO = new cc.rolando.solr.utils.SalikaIndexDAO();
			// sakilaIndexer.testQueryToRs(sakilaDAO.getData());

						//get a reference to the dynamic proxy class
			CFCDynamicProxy = SERVER.cfSolrJJavaLoader.create("com.compoundtheory.coldfusion.cfc.CFCDynamicProxy");
			httpSolrServer = SERVER.cfSolrJJavaLoader.create("org.apache.solr.client.solrj.impl.HttpSolrServer").init(application.oConfig.getsolrServiceUrl());
			
			//grab us our CFC that will act as a comparator
			// comparator = createObject("component", "StringLenComparator");
			
			//we can pass in an array of strings which name all the interfaces we want out dynamic proxy to implement
			interfaces = ["cc.rolando.solr.Indexer"];
			
			//create the proxy we will pass to the Collections object
			sakilaIndexerProxy = CFCDynamicProxy.createInstance(sakilaIndexer, interfaces);
			sakilaDaoProxy = CFCDynamicProxy.createInstance(sakilaDAO, ["cc.rolando.solr.Datasource"]);

			javaIndexManager = SERVER.cfSolrJJavaLoader.create("cc.rolando.solr.IndexManager").init(javaCast("int", "10000")
																									,sakilaDaoProxy
																									,httpSolrServer
																									,sakilaIndexerProxy);
			writeDump(sakilaIndexerProxy);
			writeDump(javaIndexManager);
			javaIndexManager.index(javaCast("boolean", "false"));

			// Collections.sort(stringArray, comparatorProxy);

			abort;
			
		break;
		case "results":
					// if query string not passed throw an error.
				if(!structKeyExists(url, "q"))
					throw("Missing query parameter");

				search = {};
				search["returnFormat"] = (structKeyExists(url, "f") ? url.f : "query");
				search["highlight"]		= (structKeyExists(url, "highlight") ? url.highlight : false);
				search["results"] = application.indexManager.search( criteria:url.q
																	, searchType:0
																	, returnFormat:search.returnFormat
																	, highlight: search.highlight	
																);
				
		break;
		case "resultsJava":
			// writeDump(application.searcher);
			url.q = (structKeyExists(url, "q")) ? url.q : "";
			solrDocs = application.searcher.search(url.q);
			// ixDoc = solrDocs.get(0);
			// writeDump(ixDoc.get("id"));
			// qResponse = application.searcher.search_response(url.q);
			// writeDump(qResponse);
			// writeDump(qResponse.getHeader());
			// HeaderResponse = SERVER.cfSolrJJavaLoader.create("cc.rolando.solr.CfFriendlySimpleOrderedMap").init(qResponse.getHeader());
			// writeDump(var:qResponse.getHeader().getAll(),label:"GetAll Header");
			// writeDump(var:HeaderResponse.toHashMap(),label:"HeaderResponse");

			/* for(ixDoc in solrDocs){
				writeOutput(ixDoc["id"] & "<br />");
			} */

			search = {};
			search["results"] = application.indexManager.arrayOfStructuresToQuery(solrDocs);
			mvc.viewName="results";
		break;
		

	}
		//set default value for view
	param name="mvc.viewName" default=mvc.event;
		//if view file exists inlcude	
	if(fileExists(expandPath("views/#mvc.includePath#/dsp#mvc.viewName#.cfm")))
		include "../views/#mvc.includePath#/dsp#mvc.viewName#.cfm";
</cfscript>

