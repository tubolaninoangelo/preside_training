<cf_presideparam name="args.title"         field="page.title"        editable="true" />
<cf_presideparam name="args.main_content"  field="page.main_content" editable="true" />

<cfscript>
	// event.include( "/js/specific/event-booking/");
	eventDetail   = prc.eventDetail  ?: queryNew("");
	eventSessions = rc.eventSessions ?: queryNew("");
	userId        = prc.userId ?: "";
	event.include("/js/specific/event-booking/");

	if( isBoolean( rc.updateSuccess ?: "" ) && rc.updateSuccess ){
		rc.confirmationMessage = args.success_update_message;
	}

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
					    		session     = {
						    		  values = ValueList(eventSessions.label)
						    		, labels = ValueList(eventSessions.label) }

					    	}
					    }
					)#

					<div class="form-group mod-submit-form mod-bordered u-aligned-center">
						<input type="submit" name="submit-update" class="btn btn-big" value="Continue">
					</div>

				</form>

			</div>

		</div>

	</div>

</cfoutput>