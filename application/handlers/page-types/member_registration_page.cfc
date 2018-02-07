component {

	property name="memberRegistrationService"	inject="MemberRegistrationService";

	public void function preHandler( event, action, eventArguments ) {

		if ( isLoggedIn() ) {
			setNextEvent( url = event.buildLink( page = "homepage" ) );
		}

	}

	private function index( event, rc, prc, args={} ) {
		// TODO: create your handler logic here
		return renderView(
			  view          = 'page-types/member_registration_page/index'
			, presideObject = 'member_registration_page'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}

	public void function submitMemberRegistrationDetails( event, rc, prc, args={} ) {

		var formName = "membership.registration";
		var formData = event.getCollectionForForm( formName );
		var persist  = {};

		formData.display_name = formData.firstname;

		var validationResult  = validateForm( formName, formData );

		if ( validationResult.validated() ) {

			var validConfirmPassword = _validConfirmPassword(
				  newPassword     = formData.password
				, confirmPassword = formData.confirm_password
			);

			if ( !validConfirmPassword ) {
				validationResult.addError( fieldName="confirm_password", message=translateResource( "alerts:confirm_password_not_match" ) );
			}

			if( memberRegistrationService.checkExistingEmail( formData.email ) ) {
				validationResult.addError( "email", translateResource( uri="alerts:email_already_exists" ) );
			}

			if( memberRegistrationService.checkExistingUserId( formData.user_id ) ) {
				validationResult.addError( "user_id", translateResource( uri="alerts:user_already_exists" ) );
			}
		}

		if ( !validationResult.validated() ) {
            persist.validationResult = validationResult;
           	persist.savedData        = formData;

            setNextEvent( url=event.buildLink( page="member_registration_page" ), persistStruct=persist );
        }

        // Save data to webuser first
        memberRegistrationService.saveMemberRegistrationDetails( argumentCollection = formData );

        // Get uniq id from webuser
        var registeredUserDetail = memberRegistrationService.getMemberDetailsByEmail( formData.email );

        // Save uniq id and data from webuser to another object
        formData.website_user_id = registeredUserDetail.id;
        memberRegistrationService.saveMemberRegisteredDetails( argumentCollection = formData );

        setNextEvent( url=event.buildLink( page="member_registration_page" ) );

	}

	private boolean function _validConfirmPassword( required string newPassword, required string confirmPassword ) {
		return arguments.newPassword == arguments.confirmPassword;
	}
}
