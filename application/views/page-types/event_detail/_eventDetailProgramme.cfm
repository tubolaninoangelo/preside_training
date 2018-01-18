<cfscript>
	eventProgramme = args.eventProgramme ?: queryNew("");
</cfscript>

<cfoutput>

	<cfif eventProgramme.recordCount>

		<h3>Programmes</h3>
		<div class="event-detail-programme">
			<cfloop query="eventProgramme">
				#label# <cfif eventProgramme.currentRow != eventProgramme.recordCount > ,</cfif>
			</cfloop>
		</div>

	</cfif>

</cfoutput>