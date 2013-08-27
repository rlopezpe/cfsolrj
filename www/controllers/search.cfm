<cfscript>
	/**
	* @author R.Lopez
	* @description A simple MVC controller
	*/
	
	import com.*;

	switch(mvc.event){
		case "index":

		break;
		case "results":
					// if query string not passed throw an error.
				if(!structKeyExists(url, "q"))
					throw("Missing query parameter");

				search = {};
				search["returnFormat"] = (structKeyExists(url, "f") ? url.f : "json");
				search["highlight"]		= (structKeyExists(url, "highlight") ? url.highlight : false);
				search["results"] = application.indexManager.search( criteria:url.q
																	, searchType:3
																	, returnFormat:search.returnFormat
																	, highlight: search.highlight	
																);

				for(doc in search.results){
					writeOutput(doc.summary & "<br />");	
				}
				writeDump(search.results);	

				

		break;
		

	}
		//set default value for view
	param name="mvc.viewName" default=mvc.event;
		//if view file exists inlcude	
	if(fileExists(expandPath("views/#mvc.includePath#/dsp#mvc.viewName#.cfm")))
		include "../views/#mvc.includePath#/dsp#mvc.viewName#.cfm";
</cfscript>

