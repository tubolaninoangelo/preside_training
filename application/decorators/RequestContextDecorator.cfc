component extends="preside.system.coldboxModifications.RequestContextDecorator" {

	public boolean function isFullyBooked( required string eventId ){

		var eventBookingsSeats = getModel( "presideObjectService" ).selectData(
			  objectName   = "event_detail"
			, selectFields = [ "seats_allocated", "seats_booked" ]
			, filter       = { "id"=arguments.eventId }
		);

		if ( len( eventBookingsSeats.seats_allocated ) && len( eventBookingsSeats.seats_booked ) ){
			if ( eventBookingsSeats.seats_booked GTE eventBookingsSeats.seats_allocated ){
				return true;
			}
		}

		return false;
	}
}