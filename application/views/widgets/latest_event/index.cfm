<cfparam name="args.widget_title" default="" />
<cfparam name="args.event_items" default="" />

<cfscript>

	latestEvents = args.latestEvents ?: queryNew( '' );

</cfscript>


<cfoutput>

	<div class="widget widget-latest-events">

		<h3>#args.widget_title#</h3>

		<div class="widget-content">

			<div class="event-details mod-featured">
				#renderView(
					  view          = "/page-types/event_detail/_item"
					, args          = {
						eventDetail = latestEvents
					}
				)#
			</div>

		</div>

	</div>

</cfoutput>
