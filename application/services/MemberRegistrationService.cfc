/**
 * @presideService
 */
component {

    // CONSTRUCTOR
    /**
     * @bCryptService.inject       bCryptService
     */

    public any function init( bCryptService ) {

        _setBCryptService( arguments.bCryptService );

        return this;
    }

    public query function saveMemberRegistrationDetails(
          required string firstname
        , required string lastname
        , required string birth_date
        , required string email
        , required string gender
        , required string address
        , required string interested_in
        , required string user_id
        , required string password
    ) {

        var display_name      = arguments.firstname & " " & arguments.lastname;
        var encryptedPassword = _getBCryptService().hashPw( arguments.password );

        return $getPresideObject("website_user").insertData( {
              login_id      = arguments.user_id
            , email_address = arguments.email
            , password      = encryptedPassword
            , display_name  = display_name
            , active        = 1
        } );

    }

    public query function saveMemberRegisteredDetails(
          required string website_user_id
        , required string firstname
        , required string lastname
        , required string birth_date
        , required string email
        , required string gender
        , required string address
        , required string interested_in
    ) {

        return $getPresideObject("member").insertData( {
              website_user_id = arguments.website_user_id
            , firstname       = arguments.firstname
            , lastname        = arguments.lastname
            , birth_date      = arguments.birth_date
            , email           = arguments.email
            , gender          = arguments.gender
            , address         = arguments.address
            , interested_in   = arguments.interested_in
        } );

    }

    public query function getMemberDetailsByEmail( required string email ) {

        return $getPresideObject( "website_user" ).selectData(
                  selectFields = [
                      "id"
                    , "email_address"
                    , "display_name"
                ]
                , filter = {
                      "email_address" = arguments.email
                }
        );
    }

    public boolean function checkExistingEmail( required string email ) {

        return $getPresideObject( "website_user" ).dataExists(
                  email_address = arguments.email
                , filter        = { email_address = arguments.email }
        );

    }

    public boolean function checkExistingUserId( required string user_id ) {

        return $getPresideObject( "website_user" ).dataExists(
                  login_id = arguments.user_id
                , filter   = { login_id = arguments.user_id }
        );

    }

    // public function sendConfirmationEmail(
    //       required struct  bookerDetails
    //     ,          boolean addPresideNotification = true
    // ) {

    //     $sendEmail(
    //           template = "EventBookingConfirmationAdmin"
    //         , to       = [ bookerDetails.email ]
    //         , args     = {
    //             event_booking_details = bookerDetails
    //         }
    //     );

    //     if( addPresideNotification ) {

    //         $getNotificationService().createNotification(
    //               topic = "eventBooking"
    //             , type  = "ALERT"
    //             , data  = {
    //                   subtopic = "submittedEventBooking"
    //                 , data     = {
    //                     booker_details = bookerDetails
    //                 }
    //             }
    //         );
    //     }
    // }

    private any function _getBCryptService() {
        return _bCryptService;
    }

    private void function _setBCryptService( required any bCryptService ) {
        _bCryptService = arguments.bCryptService;
    }
}