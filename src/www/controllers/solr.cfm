<cfscript>
	/**
	* @author R.Lopez
	* @description A simple MVC controller
	*/
	
	import cc.*;

	switch(mvc.event){
		case "index":
			application.indexManager.index();
				
		break;
		
		case "simpleSample_index":
			simpleIndex = new cc.rolando.solr.utils.SimpleIndex();

			simpleIndex.index();
		break;

		case "simpleSample_search":
			simpleIndex = new cc.rolando.solr.utils.SimpleIndex();

			param name="url.q" default="test";
			results = simpleIndex.search(criteria:url.q);
			writeDump(results);
			abort;
		break;

	}
		//set default value for view
	param name="mvc.viewName" default=mvc.event;
		//if view file exists inlcude	
	if(fileExists(expandPath("views/#mvc.includePath#/dsp#mvc.viewName#.cfm")))
		include "../views/#mvc.includePath#/dsp#mvc.viewName#.cfm";
</cfscript>

