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
			setting showdebugoutput=application.oConfig.getenableDebugOutput();

			//if session scope has been reset, recreate
/* 			if(!structKeyExists(Session,"authorized")) {
				onSessionStart();
			}
 */
 			
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
/* 			//check for direct file access restrictions
			if (!ListFindNoCase(application.oConfig.getDirectAccessFileNames(), ListLast(cgi.SCRIPT_NAME,"/"), ",")) {
				if (Not ListFindNoCase(cgi.SCRIPT_NAME,"ws", "/")) {
					location(url:application.oConfig.getAppURL(), addToken:false);
				}
			}

 */			/* check if Maintenance has been scheduled. If on maintenance period, block access to application & alert user.
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
	
	private void function setAccessCookies(){
		local.currentTime = Now();
		cookie.LastAccessTime = "#DateFormat(currentTime, 'yyyy/mm/dd')# #TimeFormat(currentTime, 'HH:mm:ss')#";
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
		// writeDump(application);abort;
		/* application.objNetUtilities 		= new cfc.utilities.NetUtilities(application.urlValidator, application.javaTypeValidator);
														,application.oConfig.getDsn()
														,application.oConfig.getSolrServiceUrl()
														,application.httpStatus
														,application.javaTypeValidator
														,application.oConfig, application.objUDF 
														,local.solrUtilities); 
		application.objErrorHandler	= new cfc.errorhandler(mailService:application.objEmail,cacheExpirationInMinutes:application.oConfig.getErrorCacheTimeout());
		application.objSystem 		= CreateObject('java', 'java.lang.System');
		application.objDocFetch		= new cfc.document_fetcher(netUtilities:application.objNetUtilities,httpStatus:application.httpStatus, javaTypeValidator:application.javaTypeValidator); //must go after urlValidator and objNetUtilities
		application.languages 		= new hero.component.gateway.gateway_language().init().getAsDictionary("abbreviation","name"); */
	}

	

	
	
	private void function makeBackwardCompatible(){
			//set expected request scope vars ***ONLY TEMPORARY*** remove after all branches have been updated to work with the new framework.
		
		if(!structKeyExists(request,"dsn")){
			
			request.dsn 			= application.oConfig.getDsn();
			request.admin_dsn		= application.oConfig.getAdminDsn();
			
			request.self			= cgi.SCRIPT_NAME;
			request.mySelf			= request.self & "?action=";
			
				//todo: figure out where is was this being initialize on previous code
			if (not structkeyexists(request,"isheronet")){
				request.isheronet=false;
			}
		}
	}
	
	private void function restartApplication(String requestedPage){
		var proceed = false;
		if(application.oConfig.getIsDev() ){
				proceed = true;
				//structClear(session);
		}else{
			
		}
		if(proceed){
			applicationStop();
			location(url=arguments.requestedPage & "?",addToken=false);
		}
	}
		private void function checkForProbes(){
		for (var key in url) {
				if ((trim(url[key]) eq "-1'") or (trim(url[key]) eq "1'" ))
					location(url:"index.cfm",addtoken:false);
				if (listfindnocase("reference_id,project_id", key ) and not application.objUDF.isnumericlist(url[key]) ){
					var id = val(url[key]);
					if (isnumeric(id) ) {
						url[key] = id;
					}
					else {
						location(url:"index.cfm",addtoken:false);
					}
				}
			}
		if ( isdefined('form')){	
				for (key in form) {
						if ((trim(form[key]) eq "-1'") or (trim(form[key]) eq "1'" ))
							location(url:"index.cfm",addtoken:false);
					} // end for key
			} //end if isdefined
		} // end checkForProbes

	/* Checks IP address for access throttling */
	private void function checkIPAddress() {
		if (
			(!application.oConfig.getIsHeroNet())
			and (
				(!StructKeyExists(url, 'action'))
				or (LCase(url.action) != 'content.wait')
			)
			and (
				(!StructKeyExists(form, 'action'))
				or (LCase(form.action) != 'content.wait')
			)
		) {
			/* This is a public page request, and the action value is not content.wait, continue */
		lock
			scope="application"
			type="exlusive"
			timeout="10"
			{			
				if ((!StructKeyExists(application, 'publicIPAddresses')) 
				or (!IsValid('struct', application.publicIPAddresses))
				or !StructKeyExists(application, 'ipCheckTime')
				or (StructKeyExists(application, 'ipCheckTime') and dateDiff('n',application.ipCheckTime,now()) gt 5 ) 						) {
					/* application.publicIPAddress either does not exist or is invalid, create it */
					application.publicIPAddresses = StructNew();
					application.ipCheckTime = now();

				}
	
				if ((StructKeyExists(cgi, 'remote_addr')) and (Trim(cgi.remote_addr) neq '')) {
					if (cgi.HTTP_USER_AGENT contains "bingbot") {
						local.key="bingbot";
					}
					else {
						local.key = cgi.remote_addr;
					}
					
					if (!StructKeyExists(application.publicIPAddresses, local.key)) {
						/* Set up IP address information as a Struct for possible future use/expansion */
						application.publicIPAddresses[local.key] = StructNew();
						application.publicIPAddresses[local.key].firstRequest = Now();
						application.publicIPAddresses[local.key].lastRequest = Now();
					}
					else if (
						(!StructKeyExists(application.publicIPAddresses[local.key], 'lastRequest'))
						or (!IsValid('date', application.publicIPAddresses[local.key].lastRequest))
						or (DateDiff('s', application.publicIPAddresses[local.key].lastRequest, Now()) >= application.oConfig.getPublicRequestThrottleTime())
					) {
						/* ipAddress object's lastRequest field is either missing, invalid or greater than the throttle time period, [re-]set to Now() */
						application.publicIPAddresses[local.key].lastRequest = Now();
					}
					else {
						/* Request is within the throttle time period */
	
						/* Store the original request URL for later use */
						session.originalRequest = '';
						if ((StructKeyExists(cgi, 'script_name')) and (cgi.script_name != '')) {
							session.originalRequest = cgi.script_name;
						}
						if ((StructKeyExists(cgi, 'query_string')) and (cgi.query_string != '')) {
							session.originalRequest = session.originalRequest & '?' & cgi.query_string;
						}
	
						/* Redirect to content.wait */
						location(url:'index.cfm?action=content.wait', addtoken:false);
					}
				}
			}
		} //end lock
	}



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