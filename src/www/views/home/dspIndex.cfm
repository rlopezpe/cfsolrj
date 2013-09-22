

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
<div style="font-size:19px;">
	<cfoutput>#application.oConfig.getBuildNo()#</cfoutput>
</div>
	changed
<cfscript>
	writeDump(application.oConfig);
</cfscript>

