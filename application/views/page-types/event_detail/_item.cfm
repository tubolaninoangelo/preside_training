<cfscript>
	eventId     = args.id 	  ?: '';
	eventDetail = args.eventDetail  ?: queryNew( '' );

</cfscript>

<cfoutput>
	<div class="row">

	<cfloop query="eventDetail">

		<div class="event-detail-item col-xs-4">

			<a href="#event.buildLink( page=id )#">
				#renderAsset(
					assetId = main_image
				)#
			</a>

			<h3 class="title"><a href="#event.buildLink( page=id )#">#title#</a></h3>

			<p>#teaser#</p>

			<cfif event_enddate LT NOW() >
				<h5><b>Expired event</b></h5>
			</cfif>

			<ul>
				<li>#dateFormat( event_startdate, "dd mmmm yyyy" )# - #dateTimeFormat( event_enddate, "dd mmmm yyyy" )#</li>
			</ul>

			<p>#renderViewlet( event="page-types.events._renderDetailRegion", args = { eventId = id  } )#</p>

		</div>

	</cfloop>

	</div>

</cfoutput>