

<div>
	<div>
		<form action="/index.cfm" method="get">
			<input type="hidden" name="action" value="search.results" />
			<label for="search"></label>
			<input type="text" name="q" id="search" size="30" />
			<input type="submit" value="search" />

		</form>
	</div>
</div>

<cfscript>
	
	writeDump(application);
</cfscript>

