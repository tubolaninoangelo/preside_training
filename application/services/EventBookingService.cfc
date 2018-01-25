/**
 * @presideService
 */
component {

    public any function init( ) {

        return this;
    }

    public string function eventBookingService(
          required string event_id
        , required string event_price
        , required string label
        , required string firstname
        , required string lastname
        , required string email
        , required string number_of_seat
        , required string total_amount
        , required string event_session
        , required string special_request
    ) {

        return $getPresideObject("event_booking_db").insertData( {
              event_id        = arguments.event_id
            , event_price     = arguments.event_price
            , label           = arguments.label
            , firstname       = arguments.firstname
            , lastname        = arguments.lastname
            , email           = arguments.email
            , number_of_seat  = arguments.number_of_seat
            , total_amount    = arguments.total_amount
            , event_session   = arguments.event_session
            , special_request = arguments.special_request
        } );

    }

}