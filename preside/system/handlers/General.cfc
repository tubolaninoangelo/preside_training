component {
	property name="applicationReloadService"  inject="applicationReloadService";
	property name="databaseMigrationService"  inject="databaseMigrationService";
	property name="applicationsService"       inject="applicationsService";
	property name="websiteLoginService"       inject="websiteLoginService";
	property name="adminLoginService"         inject="loginService";
	property name="antiSamySettings"          inject="coldbox:setting:antiSamy";
	property name="antiSamyService"           inject="delayedInjector:antiSamyService";
	property name="expressionGenerator"       inject="rulesEngineAutoPresideObjectExpressionGenerator";

	public void function applicationStart( event, rc, prc ) {
		prc._presideReloaded = true;

		_performDbMigrations();
		_populateDefaultLanguages();
		_populateAutoRulesEngineExpressions();
		announceInterception( "onApplicationStart" );
	}

	public void function applicationEnd( event, rc, prc ) {
		applicationReloadService.gracefulShutdown(
			force = url.keyExists( "force" )
		);
	}

	public void function requestStart( event, rc, prc ) {
		_xssProtect( argumentCollection = arguments );
		_reloadChecks( argumentCollection = arguments );
		_recordUserVisits( argumentCollection = arguments );
	}

	public void function notFound( event, rc, prc ) {
		var notFoundViewlet = getSetting( name="notFoundViewlet", defaultValue="errors.notFound" );
		var notFoundLayout  = "";

		if ( event.isAdminRequest() ) {
			var activeApplication = applicationsService.getActiveApplication( event.getCurrentEvent() );

			notFoundLayout = applicationsService.getLayout( activeApplication );
		} else {
			notFoundLayout  = getSetting( name="notFoundLayout" , defaultValue="Main" );
		}

		event.setLayout( notFoundLayout );
		event.setView( view="/core/simpleBodyRenderer" );

		rc.body = renderViewlet( event=notFoundViewlet );
	}

	private void function accessDenied( event, rc, prc, args={} ) {
		var accessDeniedViewlet = getSetting( name="accessDeniedViewlet", defaultValue="errors.accessDenied" );
		var accessDeniedLayout  = getSetting( name="accessDeniedLayout" , defaultValue="Main" );

		event.setLayout( accessDeniedLayout );
		event.setView( view="/core/simpleBodyRenderer" );

		rc.body = renderViewlet( event=accessDeniedViewlet, args=args );
	}

// private helpers
	private void function _xssProtect( event, rc, prc ) {
		if ( IsTrue( antiSamySettings.enabled ?: "" ) ) {
			if ( IsFalse( antiSamySettings.bypassForAdministrators ?: "" ) || !event.isAdminUser() ) {
				var policy = antiSamySettings.policy ?: "myspace";

				for( var key in rc ){
					if( IsSimpleValue( rc[ key ] ) ) {
						rc[ key ] = antiSamyService.clean( rc[ key ], policy );
					}
				}
			}

			request[ "preside.path_info"    ] = antiSamyService.clean( request[ "preside.path_info"    ] ?: "" );
			request[ "preside.query_string" ] = antiSamyService.clean( request[ "preside.query_string" ] ?: "" );
		}
	}

	private void function _reloadChecks( event, rc, prc ) {
		var anythingReloaded = false;

		if ( _requestIsExcludedFromReload( argumentCollection=arguments ) ) {
			return;
		}

		var reloadPassword = getSetting( name="reinitPassword", defaultValue="true" );
		var devSettings    = getSetting( name="developerMode" , defaultValue=false );

		if ( IsBoolean( devSettings ) ) {
			devSettings = {
				  dbSync               = devSettings
				, flushCaches          = devSettings
				, reloadForms          = devSettings
				, reloadI18n           = devSettings
				, reloadPresideObjects = devSettings
				, reloadWidgets        = devSettings
				, reloadPageTypes      = devSettings
				, reloadStatic         = devSettings
			};
		} else {
			devSettings = {
				  dbSync               = IsBoolean( devSettings.dbSync               ?: "" ) and devSettings.dbSync
				, flushCaches          = IsBoolean( devSettings.flushCaches          ?: "" ) and devSettings.flushCaches
				, reloadForms          = IsBoolean( devSettings.reloadForms          ?: "" ) and devSettings.reloadForms
				, reloadI18n           = IsBoolean( devSettings.reloadI18n           ?: "" ) and devSettings.reloadI18n
				, reloadPresideObjects = IsBoolean( devSettings.reloadPresideObjects ?: "" ) and devSettings.reloadPresideObjects
				, reloadWidgets        = IsBoolean( devSettings.reloadWidgets        ?: "" ) and devSettings.reloadWidgets
				, reloadPageTypes      = IsBoolean( devSettings.reloadPageTypes      ?: "" ) and devSettings.reloadPageTypes
				, reloadStatic         = IsBoolean( devSettings.reloadStatic         ?: "" ) and devSettings.reloadStatic
			};
		}

		lock type="exclusive" timeout="10" name="#Hash( ExpandPath( '/' ) )#-application-reloads" {
			if ( devSettings.flushCaches or ( event.valueExists( "fwReinitCaches" ) and Hash( rc.fwReinitCaches ) eq reloadPassword ) ) {
				applicationReloadService.clearCaches();
				anythingReloaded = true;
			}

			if ( devSettings.dbSync or ( event.valueExists( "fwReinitDbSync" ) and Hash( rc.fwReinitDbSync ) eq reloadPassword ) ) {
				applicationReloadService.reloadPresideObjects();
				applicationReloadService.dbSync();
				anythingReloaded = true;
			} else if ( devSettings.reloadPresideObjects or ( event.valueExists( "fwReinitObjects" ) and Hash( rc.fwReinitObjects ) eq reloadPassword ) ) {
				applicationReloadService.reloadPresideObjects();
				anythingReloaded = true;
			}

			if ( devSettings.reloadWidgets or ( event.valueExists( "fwReinitWidgets" ) and Hash( rc.fwReinitWidgets ) eq reloadPassword ) ) {
				applicationReloadService.reloadWidgets();
				anythingReloaded = true;
			}

			if ( devSettings.reloadPageTypes or ( event.valueExists( "fwReinitPageTypes" ) and Hash( rc.fwReinitPageTypes ) eq reloadPassword ) ) {
				applicationReloadService.reloadPageTypes();
				anythingReloaded = true;
			}

			if ( devSettings.reloadForms  or ( event.valueExists( "fwReinitForms" ) and Hash( rc.fwReinitForms ) eq reloadPassword ) ) {
				applicationReloadService.reloadForms();
				anythingReloaded = true;
			}

			if ( devSettings.reloadI18n or ( event.valueExists( "fwReinitI18n" ) and Hash( rc.fwReinitI18n ) eq reloadPassword ) ) {
				applicationReloadService.reloadI18n();
				anythingReloaded = true;
			}

			if ( devSettings.reloadStatic or ( event.valueExists( "fwReinitStatic" ) and Hash( rc.fwReinitStatic ) eq reloadPassword ) ) {
				applicationReloadService.reloadStatic();
				anythingReloaded = true;
			}
		}
	}

	private boolean function _requestIsExcludedFromReload( event, rc, prc ) {
		if ( prc._presideReloaded ?: false ) {
			return true;
		}

		if ( event.isAjax() ) {
			return true;
		}

		if ( ReFindNoCase( "^(assetDownload|ajaxproxy|staticAssetDownload)", event.getCurrentHandler() ) ) {
			return true;
		}

		return false;
	}

	private void function _recordUserVisits( event, rc, prc ) {
		if ( !event.isAjax() && !ReFindNoCase( "^(assetDownload|ajaxproxy|staticAssetDownload)", event.getCurrentHandler() ) ) {
			websiteLoginService.recordVisit();
			adminLoginService.recordVisit();
		}
	}

	private void function _performDbMigrations() {
		databaseMigrationService.migrate();
	}

	private void function _populateDefaultLanguages() {
		if ( isFeatureEnabled( "multilingual" ) ) {
			getModel( "multilingualPresideObjectService" ).populateCoreLanguageSet();
		}
	}

	private void function _populateAutoRulesEngineExpressions() {
		expressionGenerator.generateAndRegisterAutoExpressions();
	}
}