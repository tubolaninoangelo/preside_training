/**
 * @presideService
 */
component {

    public any function init( ) {

        return this;
    }

    public string function saveEventBookingDetail(
          required string event_id
        , required string website_user
        , required string event_title
        , required string event_price
        , required string firstname
        , required string lastname
        , required string email
        , required string number_of_seat
        ,          string total_amount
        ,          string session
        ,          string special_request
    ) {

        return $getPresideObject("event_booking").insertData( {
              event_id        = arguments.event_id
            , website_user    = arguments.website_user
            , event_title     = arguments.event_title
            , event_price     = arguments.event_price
            , firstname       = arguments.firstname
            , lastname        = arguments.lastname
            , email           = arguments.email
            , number_of_seat  = arguments.number_of_seat
            , total_amount    = arguments.total_amount
            , session         = arguments.session
            , special_request = arguments.special_request
        } );

    }

    public query function getEventBookedDetailsByUser( required string eventId, string userId="" ) {

        return $getPresideObject( "event_booking" ).selectData(
                  selectFields = [
                      "id"
                    , "event_title"
                    , "event_price"
                    , "firstname"
                    , "lastname"
                    , "email"
                    , "number_of_seat"
                    , "session"
                    , "total_amount"
                    , "special_request"
                ]
                , filter       = {
                      "event_id"     = arguments.eventId
                    , "website_user" = arguments.userId
                }
        );
    }

    public boolean function isEventBookable( required string eventId ) {
        if ( !Len( Trim( arguments.eventId ) ) ) {
            return false;
        }

        var bookableEvent = $getPresideObject( "event_detail" ).dataExists(
              id     = arguments.eventId
            , filter = "bookable = 1 AND event_startdate > Now()"
        );

        return bookableEvent;
    }

    public boolean function checkExistingEmail( required string email ) {

        return $getPresideObject( "event_booking" ).selectData(
                  filter       = "email = :email"
                , filterParams = { email = arguments.email }
        ).recordCount;

    }

    public void function sendConfirmationEmail(
          required struct  bookerDetails
        ,          boolean addPresideNotification = true
    ) {

        $sendEmail(
              template = "EventBookingConfirmationAdmin"
            , to       = [ bookerDetails.email ]
            , args     = {
                event_booking_details = bookerDetails
            }
        );

        if( addPresideNotification ) {

            $getNotificationService().createNotification(
                  topic = "eventBooking"
                , type  = "ALERT"
                , data  = {
                      subtopic = "submittedEventBooking"
                    , data     = {
                        booker_details = bookerDetails
                    }
                }
            );
        }
    }
}