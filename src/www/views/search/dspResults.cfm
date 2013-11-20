<html>
	<head>
		<style type="text/css">
			div.result { padding-bottom: 8px;}
			div.rTitle { font-size: 16px; color:blue;}
			div.rSummary { font-size: 14px; font-style: italic;}
			div.rReleaseYear{float:left;}
			div.rReleaseYear, div.rActors { font-size: 12px; font-style: italic; color:gray;}

		</style>
	</head>
	<body>
		<div class="results">
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