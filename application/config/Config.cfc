component extends="preside.system.config.Config" {

	public void function configure() {
		super.configure();

		settings.preside_admin_path  = "training_admin";
		settings.system_users        = "sysadmin";
		settings.default_locale      = "en";

		settings.default_log_name    = "training";
		settings.default_log_level   = "information";
		settings.sql_log_name        = "training";
		settings.sql_log_level       = "information";

		settings.ckeditor.defaults.stylesheets.append( "css-bootstrap" );
		settings.ckeditor.defaults.stylesheets.append( "css-layout" );

		settings.features.websiteUsers.enabled = true;

		settings.assetmanager.types.document = {
		      pdf  = { serveAsAttachment=true, mimeType="application/pdf"    }
		    , csv  = { serveAsAttachment=true, mimeType="application/csv"    }
		    , doc  = { serveAsAttachment=true, mimeType="application/msword" }
		    , dot  = { serveAsAttachment=true, mimeType="application/msword" }
		};

		_setupEmailSettings();
		_setupNotificationTopics();
		_setupInterceptors();

		coldbox.requestContextDecorator = "app.decorators.RequestContextDecorator";

	}

	private void function _setupEmailSettings() {
		settings.email.templates.eventBookingConfirmationAdmin = { feature="cms", recipientType="anonymous", parameters=[
			{ id="event_booking_details", required=true }
		] };
	}

	private void function _setupNotificationTopics() {
		settings.notificationTopics = settings.notificationTopics ?: [];
		settings.notificationTopics.append( "eventBooking" );
	}

	private void function _setupInterceptors() output=false {
		interceptors.prepend( { class="app.interceptors.DataChangeInterceptor" , properties={} } );
	}
}
