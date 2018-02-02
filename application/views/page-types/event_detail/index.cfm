<cf_presideparam name="args.id"					field="page.id"							/>
<cf_presideparam name="args.title"				field="page.title"						editable="true" />
<cf_presideparam name="args.main_content"		field="page.main_content"				editable="true" />
<cf_presideparam name="args.parent_page"		field="page.parent_page"				/>
<cf_presideparam name="args.event_startdate"	field="event_detail.event_startdate"	/>
<cf_presideparam name="args.event_enddate"		field="event_detail.event_enddate"		/>
<cf_presideparam name="args.document"			field="event_detail.event_document"		/>
<cf_presideparam name="args.event_price" 		field="event_detail.event_price"	 	/>
<cf_presideparam name="args.bookable" 			field="event_detail.event_bookable"	/>

<cfscript>
	relatedEvents = args.relatedEvents ?: "";
	// event.include("/js/specific/components/event-booking/");
</cfscript>

<cfoutput>

	<div class="main-wrapper">

		<div class="row">

			<div class="main-content col-xs-8">

				<h1>#args.title#</h1>
				#args.main_content#
				<ul>
					<li>#dateFormat( args.event_startdate, "dd mmmm yyyy" )# - #dateTimeFormat( args.event_enddate, "dd mmmm yyyy" )#</li>
				</ul>

				<cfif NOT isEmpty( args.document ) AND args.event_enddate < NOW() >

					<p><a href="#event.buildLink( assetId=args.document )#">
						#renderAsset(
							assetId = args.document
						)# Download PDF
					</a></p>

				</cfif>


				<p>#renderViewlet( event="page-types.events._renderDetailRegion", args={ eventId= args.id } )#</p>

				<cfif args.bookable >

					<a href="#event.buildLink( page="event_booking_page", queryString="event_id=#args.id#" )#" class="btn">Book an event</a>

				</cfif>

				#renderViewlet( event="page-types.event_detail._renderEventDetailProgram" )#

				#renderViewlet( event="page-types.event_detail._renderRelatedEventsByRegion", args={ parentPage=args.parent_page } )#


				<cfif args.event_enddate < NOW() >
					#renderView( view="widgets/disqus/index" )#
				</cfif>

			</div>

		</div>

	</div>



</cfoutput>