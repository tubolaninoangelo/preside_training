<cf_presideparam name="args.title"         field="page.title"        editable="true" />
<cf_presideparam name="args.main_content"  field="page.main_content" editable="true" />

<cfscript>
	// event.include( "/js/specific/event-booking/");
	eventDetail   = prc.eventDetail  ?: queryNew("");
	eventSessions = rc.eventSessions ?: queryNew("");
	eventSeats    = rc.eventSeats    ?: queryNew("")
	userId        = prc.userId       ?: "";


	if( len( eventSeats.seats_allocated ) ) {

		eventSeatsVal = [];

		for( x = 1 ; x < eventSeats.seats_allocated; x++ ) {
			eventSeatsVal[x] = x;
		}
	}

	event.include("/js/specific/event-booking/");

</cfscript>

<cfoutput>

	<div class="main-wrapper">

		<div class="row">
			<div class="main-content col-xs-8 col-sm-offset-2">

				<h2>Event booking for: #eventDetail.title#</h2>
				<p>Price : #eventDetail.event_price#</p>
				<p>#userId#</p>
				<form id="eventBooking" method="post" action="#event.buildLink( linkTo = 'page-types.event_booking_page.submitEventBooking' )#">
					<input type="hidden" name="event_title" value="#eventDetail.title#">
					<input type="hidden" name="event_price" id="event_price" value="#eventDetail.event_price#">

					#renderForm(
						  formName            = "event-booking.booking"
						, context             = "website"
						, fieldLayout         = "formcontrols.layout.formfield.website"
					    , savedData			  = rc.savedData  ?: {}
						, validationResult    = rc.validationResult ?: ""
					    , includeValidationJs = true
					    , additionalArgs      = {
					    	fields = {
					    		  session        = {
						    		  values = ValueList(eventSessions.label)
						    		, labels = ValueList(eventSessions.label)
						    	}
						    	, number_of_seat = {
						    		  values = ArrayToList(eventSeatsVal)
						    		, labels = ArrayToList(eventSeatsVal)
						    	}

					    	}
					    }
					)#

					<div class="form-group mod-submit-form mod-bordered u-aligned-center">
						<input type="submit" name="submit-update" class="btn btn-big" value="Submit">
					</div>

				</form>

			</div>

		</div>

	</div>

</cfoutput>