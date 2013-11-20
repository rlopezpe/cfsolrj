<html>
<head>
	<title>CFSolrJ Simple</title>

	<style type="text/css">
		em{
			background-color: yellow;
		}
	</style>
</head>
<body>


<cfscript>
	param name="url.event" default="search";
	viewsPath = "views/";

		// initialize simple index manager
	simpleIndex = application.com.simpleIndex;

	switch(url.event){

		case "index":
			simpleIndex.index();
			include "#viewsPath#dspIndexResults.cfm";
		break;
		
		case "search":
			param name="url.q" default="monkey"; // default query string for demo

			search = {};
			search["results"] = simpleIndex.search(criteria:url.q);

			include "#viewsPath#dspSearchResults.cfm";
		break;
	}
</cfscript>


</body>
</html>