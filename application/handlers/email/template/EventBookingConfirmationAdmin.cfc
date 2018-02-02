component {
	property name="presideObjectService" inject="PresideObjectService";

	private struct function prepareParameters(
		required struct event_booking_details
	) {
		var args = {};
		args.eventBookingDetails = arguments.event_booking_details;

		return {
			event_booking_details = {
				  html = Trim( renderView( view="/email/template/eventBookingConfirmationAdmin/_eventBookingDetailsHtml", args=args ) )
				, text = Trim( renderView( view="/email/template/eventBookingConfirmationAdmin/_eventBookingDetailsText", args=args ) )
			}
			, firstname             = args.eventBookingDetails.firstname
			, lastname              = args.eventBookingDetails.lastname
			, number_of_seat        = args.eventBookingDetails.number_of_seat

		};
	}

	private struct function getPreviewParameters() {
		var args = {};

		args.eventBookingDetails = {
			  event_title     : "Event title sample"
			, firstname       : "Nino Angelo"
			, lastname        : "Tubola"
			, number_of_seat  : "3"
			, total_amount    : "9000"
			, session         : "Session"
			, special_request : "Lorem ipsum doler"
		}

		return {
			  event_booking_details = {
				  html = Trim( renderView( view="/email/template/eventBookingConfirmationAdmin/_eventBookingDetailsHtml", args=args ) )
				, text = Trim( renderView( view="/email/template/eventBookingConfirmationAdmin/_eventBookingDetailsText", args=args ) )
			}
			, firstname             = args.eventBookingDetails.firstname
			, lastname              = args.eventBookingDetails.lastname
			, number_of_seat        = args.eventBookingDetails.number_of_seat
		};
	}

	private string function defaultSubject() {
		return "Event Booking";
	}

	private string function defaultHtmlBody() {
		return renderView( view="/email/template/eventBookingConfirmationAdmin/defaultHtmlBody" );
	}

	private string function defaultTextBody() {
		return renderView( view="/email/template/eventBookingConfirmationAdmin/defaultTextBody" );
	}

}