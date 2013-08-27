<html>
<head>
	<title></title>

	<style type="text/css">
		em{
			background-color: yellow;
		}
	</style>
</head>
<body>

</body>
</html>
<cfscript>
	mvc = {};
	mvc["folderDelim"]	= "/";

	mvc["action"]		= (structKeyExists(url,"action") ) ? url.action : "home.index";
	mvc["event"]		= listLast(mvc.action,".");
	mvc["includePath"]  = "";


	if(listLen(mvc.action,".")>1){
		mvc.includePath = listChangeDelims(mvc.action, mvc.folderDelim, ".");
		mvc.includePath = listDeleteAt(mvc.includePath, listLen(mvc.includePath, mvc.folderDelim), mvc.folderDelim);
	}
	mvc["fullPath"] = "controllers/" & mvc.includePath & ".cfm";
	include mvc.fullPath;
</cfscript>