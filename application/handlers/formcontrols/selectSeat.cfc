component {
	property name="presideObjectService" inject="PresideObjectService";

	public string function website( event, rc, prc, args={} ) {
		args.values  = args.values  ?: "";
		args.labels  = args.labels  ?: "";

		if( !isEmpty( args.object ?: "" ) ){
			var seatsAvailable = presideObjectService.selectData(
				  objectName   = args.object
				, selectFields = [ "seats_allocated", "seats_booked" ]
				, filter       = { id = rc.event_id}
			);

			if ( !len( seatsAvailable.seats_booked ) ){
				seatsAvailable.seats_booked = 0;
			}

			if ( len( seatsAvailable.seats_allocated ) ){
				args.seatsAvailable = seatsAvailable.seats_allocated - seatsAvailable.seats_booked;
			}
		}

		return renderView( view="/formcontrols/selectSeat/website", args=args );
	}
}