component {

	property name="eventBookingService"          inject="EventBookingService";

	private function index( event, rc, prc, args={} ) {

		return renderView(
			  view          = 'page-types/event_booking/index'
			, presideObject = 'event_booking'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}

	public void function saveEventBooking( event, rc, prc, args={} ) {

		var formName        = "event-booking.register";
		var eventBooking    = event.getCollectionForForm( formName );
		var persist         = {};
		var eventSeatNumber = isEmpty( eventBooking.number_of_seat ) ?: 0;

		eventBookingData = {
			  event_id        = eventBooking.event_id
			, event_price     = eventBooking.event_price
			, label           = eventBooking.firstname & " " & eventBooking.lastname
			, firstname       = eventBooking.firstname
			, lastname        = eventBooking.lastname
			, email           = eventBooking.email
			, number_of_seat  = eventSeatNumber
			, total_amount    = eventBooking.event_price * eventSeatNumber
			, event_session   = eventBooking.session
			, special_request = eventBooking.special_request
		}

		var validationResult  = validateForm( formName, eventBookingData );


        if ( !validationResult.validated() ) {
            persist.validationResult = validationResult;
           	persist.savedData        = eventBookingData;

            setNextEvent( url=event.buildLink( page="event_booking" ), persistStruct=persist );
        }

        eventBookingService.eventBookingService( argumentCollection = eventBookingData  );

        setNextEvent( url=event.buildLink( linkTo = 'page-types.event_booking.successbooking' ) );

	}


}
