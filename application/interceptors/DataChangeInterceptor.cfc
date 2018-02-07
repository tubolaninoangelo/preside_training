component extends="coldbox.system.Interceptor" {

	property name="presideObjectService" inject="provider:PresideObjectService";
	property name="eventBookingService"  inject="provider:EventBookingService";

	public void function postInsertObjectData( required any event, required struct interceptData ) {
		var interceptCondition = interceptData.objectName  == 'event_booking'
							  && structKeyExists( interceptData.data, "status" )
							  && interceptData.data.status == "1";

		if( interceptCondition ) {
			var formData         = event.getcollectionforform();
			var formName         = ArrayToList(event.getsubmittedpresideforms());
			var validationResult = formsService.validateForm( formName, formData );

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