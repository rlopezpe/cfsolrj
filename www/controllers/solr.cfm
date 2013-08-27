<cfscript>
	/**
	* @author R.Lopez
	* @description A simple MVC controller
	*/
	
	import cc.*;

	switch(mvc.event){
		case "index":
			application.objIndexManager.index();
				
		break;
		

	}
		//set default value for view
	param name="mvc.viewName" default=mvc.event;
		//if view file exists inlcude	
	if(fileExists(expandPath("views/#mvc.includePath#/dsp#mvc.viewName#.cfm")))
		include "../views/#mvc.includePath#/dsp#mvc.viewName#.cfm";
</cfscript>

