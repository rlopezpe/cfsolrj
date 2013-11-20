<html>
	<head>
		<style type="text/css">
			div.result { padding-bottom: 8px;}
			div.rTitle { font-size: 16px; color:blue;}
			div.rSummary { font-size: 14px; font-style: italic;}
			div.rReleaseYear{float:left;}
			div.rReleaseYear, div.rActors, div.small { font-size: 12px; font-style: italic; color:gray;}

		</style>
	</head>
	<cfscript>
		param name="url.q" default="";
	</cfscript>
	<body>
		<div>
			<div>
				<form action="index.cfm?event=search" method="get">
					<input type="hidden" name="action" value="search.results" />
					<label for="search"></label>
					<input type="text" name="q" id="search" size="30" value="<cfoutput>#url.q#</cfoutput>" />
					<input type="submit" value="search" />
					

				</form>
			</div>
		</div>		
		<div class="results">
		<cfif structKeyExists(search,"results") >
			<div class="small">Search executed in <cfoutput>#search.results.queryTime#</cfoutput> ms</div>
			<div class="small">Search + Network transfer in <cfoutput>#search.results.networkTime#</cfoutput> ms</div>
		</cfif>
		<cfoutput query="search.results">
			<div class="result" id="result_#key#">
				<div class="rTitle">
					#title#
				</div>
				<div class="rSummary">
					#summary#
				</div>
				<div class="rReleaseYear">
					#release_year#&nbsp;
				</div>
					
				<div class="rActors">
				<cfif structKeyExists(search.results, "actors") >
					#actors#
				<cfelse>
				&nbsp;
				</cfif>
				</div>
			</div>
		</cfoutput>
		</div>
	</body>
</html>