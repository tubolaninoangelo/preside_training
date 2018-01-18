<cfscript>
	relatedEvents = args.relatedEvents ?: queryNew( '' );

</cfscript>

<cfoutput>

	<cfif relatedEvents.recordCount >

		<h3>Related news:</h3>

		<div class="event-details">
			#renderView(
				  view   = "/page-types/event_detail/_item"
				, args   = { eventDetail = relatedEvents }
			)#

		</div>

	</cfif>

</cfoutput>