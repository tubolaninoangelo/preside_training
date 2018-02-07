component {

	property name="eventBookingService"	inject="EventBookingService";
	property name="eventService"		inject="EventService";

	public void function preHandler( event, action, eventArguments ) {
		var eventId      = rc.event_id;
		prc.eventDetail  = eventService.getEventDetailsById( eventId )  ?: queryNew("");
		rc.eventSessions = eventService.getEventSessionsById( eventId ) ?: queryNew("");
		rc.eventSeats    = eventService.getEventSeatsById( eventId )    ?: queryNew("");

		if( !prc.eventDetail.recordCount && eventBookingService.isEventBookable( eventId ) ) {
			event.notFound();
		}

		prc.userId = getLoggedInUserId() ?: "";

	}

	private function index( event, rc, prc, args={} ) {

		return renderView(
			  view          = 'page-types/event_booking_page/index'
			, presideObject = 'event_booking_page'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}

	public void function submitEventBooking( event, rc, prc, args={} ) {

		var formName     = "event-booking.booking";
		var formData = event.getCollectionForForm( formName );
		var persist      = {};

		formData.event_id     = rc.event_id;
		formData.website_user = prc.userId;
		formData.event_title  = rc.event_title;
		formData.event_price  = rc.event_price;
		formData.total_amount = formData.event_price * formData.number_of_seat;

		var validationResult  = validateForm( formName, formData );

		if ( validationResult.validated() ) {

			if( eventBookingService.checkExistingEmail(formData.email) ) {
				validationResult.addError( "email", translateResource( uri="alerts:email_already_exists" ) );
			}

			if( formData.number_of_seat LT 1 ) {
				validationResult.addError( "number_of_seat", translateResource( uri="alerts:number_of_seats_invalid" ) );
			}
		}

        if ( !validationResult.validated() ) {

            persist.validationResult = validationResult;
           	persist.savedData        = formData;

            setNextEvent( url=event.buildLink( page="event_booking_page" ), persistStruct=persist, queryString="event_id=#rc.event_id#" );
        }

        eventBookingService.saveEventBookingDetail( argumentCollection =formData  );

        // Send email and admin notification
		eventBookingService.sendConfirmationEmail(
			bookerDetails = queryRowToStruct( eventBookingService.getEventBookedDetailsByUser( eventId=rc.event_id, userId=prc.userId ) )
		);

		setNextEvent( url=event.buildLink( linkTo = 'page-types.event_booking_page.successbooking' ));

	}

}
