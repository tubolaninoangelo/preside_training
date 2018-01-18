<cf_presideparam name="args.pageId"				field="page.id"          	 	default=""      />
<cf_presideparam name="args.title"				field="page.title"				editable="true" />
<cf_presideparam name="args.main_content"		field="page.main_content"		editable="true" />
<cf_presideparam name="args.main_image"			field="page.main_image"			editable="true" />
<cf_presideparam name="args.bottom_content"		field="page.bottom_content"		editable="true" />
<cf_presideparam name="args.sidebar_content"	field="page.sidebar_content"	editable="true" />
<cf_presideparam name="args.items_per_page" />

<cfscript>
	eventList          = args.eventDetails 		 ?: queryNew("");
	eventRegionFilter  = args.regionFilter 		 ?: queryNew("");
	activeRegionFilter = args.activeRegionFilter ?: "";
	activeCategories   = args.eventCategories    ?: queryNew("");
</cfscript>

<cfoutput>

	<div class="main-wrapper">

		<div class="row">

			<div class="main-content col-xs-8">

				<h1>#args.title#</h1>

				#args.main_content#

				<div class="event-details">
					#renderView(
						  view          = "/page-types/event_detail/_item"
						, args          = {
							eventDetail = eventList
						}
					)#

				</div>

				#renderViewlet( event="page-types.events._renderFeaturedEvent", args={ eventId = args.pageId } )#

				#args.bottom_content#

			</div>

			<aside class="sidebar col-xs-4">

				<div class="widget widget-filter">
					<h3>Region filter</h3>
					<form action="#event.buildLink( page=event.getCurrentPageId() )#" method="get" >
						<cfloop query="eventRegionFilter" >
							<div>
								<label>
									<input type="checkbox" value="#id#" name="region" <cfif listFind(activeRegionFilter, id) >checked</cfif> > #label#
								</label>
							</div>
						</cfloop>
						<input type="submit" value="Submit" />
					</form>
				</div>

				#args.sidebar_content#

			</aside>

		</div>

	</div>

</cfoutput>