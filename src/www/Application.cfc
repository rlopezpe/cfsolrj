component{

	this.name = "CFSolrJDemo";
	this["sessionManagement"]	= true;
	this["scriptProtect"]		= true;
	this.mappings 				= {};  //initialize the mappings property
	
		//set EC mapping manually
	this.mappings["/environmentConfig"] = expandPath("/devLib/environmentConfig");
	this.mappings["/javaLoader"]	 	= expandPath("/devLib/javaloader_v1.1");
	this.mappings["/cc"]	 	= expandPath("../cc");

	//******************************************** END of Implicit Constructor ********************************************

		/* OnApplicationStart() */
	public function onApplicationStart(){
	
			//erase JavaLoader from server scope if present
			//execute environmentConfig
		initializeEnvironmentConfig();
		
		trace(text:"Replacing cfSolrJJavaLoader from Server scope...");
		structDelete(Server, "cfSolrJJavaLoader");
		loadJavaLoader();
		/* writeDump(server);
		writeDump(server.CFSOLRJJAVALOADER.GETCLASSLOADPATHS());
		writeDump(application);
		abort; */
		loadObjectFactory();
		application["applicationResetTime"]	= dateformat(now()) & " -- " & timeformat(now())		;
		application.ipCheckTime = now();
		trace(text:"Application #application.applicationName# started successfully (#application.applicationResetTime#).");

		
	}
	
		//onRequestStart()
	public function onRequestStart(String requestedPage) {
			 setting showdebugoutput	 = structKeyExists(application,"oConfig") ? application.oConfig.getenableDebugOutput() : false;	
			
 			
			//check if environmentConfig needs to be reset
			if (StructKeyExists(application,"resetEC") and application.resetEC) {
				application.resetEC	= false;
				trace(text:"Reloading EnvironmentConfig");
				initializeEnvironmentConfig();
			}
			
			//check if a restart/flush is requested
			if (StructKeyExists(url, "flush")) {
				trace(text:"Restarting the Application...");
				writeLog(text:"Application restarted manually via flush",type:"information",file:"HERO");
				restartApplication(arguments.requestedPage);
			}
		
		 	/* check if Maintenance has been scheduled. If on maintenance period, block access to application & alert user.
			A time window can be configured to warn users of upcoming maintenance, so that they can plan ahead.	*/
			// checkForMaintenance();

			//load Object factory (this can be improved)
			/*** NOTE: this should be loaded in Application.cfc, and the IF statement below would be unnecessary,
			 but is required here while the objects loaded by the factory are dependent on the Request scope. ***/	
	}

	public void function onRequestEnd(){
	// writeDump(var:session,abort=true);
//writeDump(var:session.projectpermissions,output:"console");

	}
	
		//onSessionStart()
	public boolean function onSessionStart(){
			//if Cookies are persisted, change them to non-persistent cookies
		if(StructKeyExists(cookie, "cfid") and structKeyExists(cookie,"cftoken")){
			tempID				= cookie.cfid;
			tempToken			= cookie.cftoken;
			cfcookie.cfid 		= tempID;
			cfcookie.cfToken	= TempToken;
		}
			//this event should only happen *Once*, no need for locking here
		session["authorized"]	= false;
		session["exception"]	= false;
		session["targetURL"]	= StructNew();
		trace(text:"Session initialized...");
		return true;
	}
	
		//onSessionEnd
	public void function onSessionEnd(){
	}
	
		/*@output true*/
	public void function onError(any exception,String eventName){
		if(structKeyExists(application,"objErrorHandler"))
			application.objErrorHandler.registerError(argumentCollection:arguments);
		else{
				//todo: write code to still attempt to send email if this code is ever executed.
			throw(object:arguments.exception);		
			abort;
		}
	}

		/******************************************************
    	UDF Methods
    	******************************************************/    

	 public void function loadObjectFactory(String path="cfc"){
		
			//for a list of static vars and the values see http://hc.apache.org/httpclient-3.x/apidocs/org/apache/commons/httpclient/HttpStatus.html. You can also cfdump the object
		
		application.httpStatus 				= SERVER.cfSolrJJavaLoader.create("org.apache.commons.httpclient.HttpStatus").init(); //loads Static class HttpStatus
		application.urlValidator 			= SERVER.cfSolrJJavaLoader.create("cc.rolando.validation.UrlValidatorHero").init();
		application.javaTypeValidatorJAVA	= SERVER.cfSolrJJavaLoader.create("cc.rolando.validation.JavaObjectTypeValidator").init();
		local.solrUtilities					= SERVER.cfSolrJJavaLoader.create("cc.rolando.utils.SolrUtils").init();
		application.javaTypeValidator 		= new cc.rolando.validation.JavaTypeValidator(application.javaTypeValidatorJAVA);

		local.salikaDao						= new cc.rolando.solr.utils.SalikaIndexDAO();

		application.indexManager			= new cc.rolando.solr.utils.indexManager(application.oConfig.getRecordsPerIndex()
																				, "cfbookclub"
																				, application.oConfig.getsolrServiceUrl()
																				, application.httpStatus
																				, application.javaTypeValidator 
																				, application.oConfig
																				, local.solrUtilities
																				, local.salikaDao
																				);
	}

	

	
	

	private void function restartApplication(String requestedPage){
		var proceed = false;
		if(application.oConfig.getIsDev() ){
				proceed = true;
				//structClear(session);
		}else{
			if(structKeyExists(url,"flush") && url.flush=="letme")
				proceed = true;
		}

		if(proceed){
			applicationStop();
			// structClear(application);
			var flushParamIx = listContainsNoCase(cgi.query_string, "flush", "&");
			local.queryString = (flushParamIx) ? listDeleteAt(cgi.query_string, local.flushParamIx, "&") : "";
			location(url=arguments.requestedPage & "?" & local.queryString ,addToken=false);
		}
	}

	/* Checks IP address for access throttling */


		/* initializes EnvironmentConfig and places it in the Application scope */
	private void function initializeEnvironmentConfig(){
			// load environmentConfig
		var ECService = new environmentConfig.model.EnvironmentService();
			//Initializes EnvironmentConfig based on settings in the config/environment.xml.cfm file 
		ECService.initEnvironmentConfig( 'config/environment.xml.cfm' );
	}
	
	private array function getJavaJarPaths(){
		var classPaths = [];
		var jarPaths = application.oConfig.getJavaJarPaths();

		for(path in jarPaths){
			arrayAppend(local.classPaths,jarPaths[path]);
		}
		return classPaths;
	}
	
	private void function loadJavaLoader(){
			//load javaLoader
			// writeDump(getJavaJarPaths());abort;
		if(!structKeyExists(server,"cfSolrJJavaLoader"))	
			server.cfSolrJJavaLoader = createObject("component", "javaloader.JavaLoader").init(getJavaJarPaths(),(val(left(server.coldfusion.productVersion,2)) > 8) ? true : false);
	}

	
	

}