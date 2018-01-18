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

		settings.features.websiteUsers.enabled = false;


		settings.assetmanager.types.document = {
		      pdf  = { serveAsAttachment=true, mimeType="application/pdf"    }
		    , csv  = { serveAsAttachment=true, mimeType="application/csv"    }
		    , doc  = { serveAsAttachment=true, mimeType="application/msword" }
		    , dot  = { serveAsAttachment=true, mimeType="application/msword" }
		};

	}
}
