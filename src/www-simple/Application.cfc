component{

	this.name = "CFSolrJDemo-Simple";

		//set application mappings
	this.mappings 				= {};  //initialize the mappings property
	this.mappings["/cc"]	 			= expandPath("../cc");

	//******************************************** END of Implicit Constructor ********************************************

		/* OnApplicationStart() */
	public function onApplicationStart(){
		
			// initialize simple index manager
		application["com"]["simpleIndex"] = new cc.rolando.solr.utils.SimpleIndex();
		application["applicationResetTime"]	= dateformat(now()) & " - " & timeformat(now())		;
		writeDump(var:"Application #application.applicationName# started successfully (#application.applicationResetTime#).",output:"console");
	
	}
		//onRequestStart()
	public function onRequestStart(String requestedPage) {
		setting showdebugoutput	 = false;	
		
			//check if a restart/flush is requested
		if (StructKeyExists(url, "flush")) {
			trace(text:"Restarting the Application...");
			restartApplication(arguments.requestedPage);
		}
	
	}

		/*@output true*/
	public void function onError(any exception,String eventName){
			// simply dump the error to the screen
		writeDump(var:local, label:"Exception details");
	}

		/******************************************************
    	UDF Methods
    	******************************************************/    

	private void function restartApplication(String requestedPage){

		if(structKeyExists(url,"flush") ){
			applicationStop();
			var flushParamIx = listContainsNoCase(cgi.query_string, "flush", "&");
			local.queryString = (flushParamIx) ? listDeleteAt(cgi.query_string, local.flushParamIx, "&") : "";
			location(url=arguments.requestedPage & "?" & local.queryString ,addToken=false);
		}
	}
}