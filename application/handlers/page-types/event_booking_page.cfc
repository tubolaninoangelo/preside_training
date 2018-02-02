component {

	property name="eventBookingService"	inject="EventBookingService";
	property name="eventService"		inject="EventService";

	public void function preHandler( event, action, eventArguments ) {
		var eventId      = rc.event_id;
		prc.eventDetail  = eventService.getEventDetailsById( eventId )  ?: queryNew("");
		rc.eventSessions = eventService.getEventSessionsById( eventId ) ?: queryNew("");

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

		var formName        = "event-booking.booking";
		var eventBooking    = event.getCollectionForForm( formName );
		var persist         = {};

		eventBooking.event_id     = rc.event_id;
		eventBooking.website_user = prc.userId;
		eventBooking.event_title  = rc.event_title;
		eventBooking.event_price  = rc.event_price;
		eventBooking.total_amount = eventBooking.event_price * eventBooking.number_of_seat;

		var validationResult  = validateForm( formName, eventBooking );

		if( eventBookingService.checkExistingEmail(eventBooking.email) ) {
			validationResult.addError( "email", translateResource( uri="alerts:email_already_exists" ) );
		}

        if ( !validationResult.validated() ) {
            persist.validationResult = validationResult;
           	persist.savedData        = eventBooking;

            setNextEvent( url=event.buildLink( page="event_booking_page" ), persistStruct=persist, queryString="event_id=#rc.event_id#" );
        }

        eventBookingService.saveEventBookingDetail( argumentCollection = eventBooking  );

        // Send email and admin notification
		eventBookingService.sendConfirmationEmail(
			bookerDetails = queryRowToStruct( eventBookingService.getEventBookedDetailsByUser( eventId=rc.event_id, userId=prc.userId ) )
		);

		setNextEvent( url=event.buildLink( linkTo = 'page-types.event_booking_page.successbooking' ));

	}

}
