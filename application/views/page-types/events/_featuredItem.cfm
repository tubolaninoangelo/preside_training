<cfscript>

	featuredEvents = args.featuredEvents ?: queryNew("");

</cfscript>

<cfoutput>

	<hr>

	<h3>Featured Events</h3>
	<div class="event-details mod-featured">

		#renderView(
			  view          = "/page-types/event_detail/_item"
			, args          = {
				eventDetail = featuredEvents
			}
		)#

	</div>

</cfoutput>