<cfscript>

	regionList = args.regionList ?: queryNew("");

</cfscript>

<cfoutput>

	<cfif regionList.recordCount >
		Region:
		<cfloop query="regionList" index="i">
			#label#
		</cfloop>
	</cfif>

</cfoutput>