<cfscript>
	setUniqueUrls( false );
	setExtensionDetection( false );
	setBaseUrl( "/" );

	function pathInfoProvider( event ) output=false {
		var requestData = GetHttpRequestData();
		var uri         = ListFirst( ( requestData.headers['X-Original-URL'] ?: cgi.path_info ), '?' );
		var qs          = "";

		if ( !Len( Trim( uri ) ) ) {
			uri = request[ "javax.servlet.forward.request_uri" ] ?: "";

			if ( !Len( Trim( uri ) ) ) {
				uri = ReReplace( ( cgi.request_url ?: "" ), "^https?://(.*?)/(.*?)(\?.*)?$", "/\2" );
			}
		}

		if ( ListLen( requestData.headers['X-Original-URL'] ?: "", "?" ) > 1 ) {
			qs = ListRest( requestData.headers['X-Original-URL'], "?" );
		}
		if ( !Len( Trim( qs ) ) ) {
			qs = request[ "javax.servlet.forward.query_string" ] ?: ( cgi.query_string ?: "" );
		}

		request[ "preside.path_info" ]    = uri;
		request[ "preside.query_string" ] = qs;

		return uri;
	}


	appMapping = getSetting( "appMapping" );
	if ( FileExists( "#appMapping#/config/Routes.cfm" ) ) {
		include template="#appMapping#/config/Routes.cfm";
	}

	getSetting( "activeExtensions" ).each( function( ext ){
		if ( FileExists( ext.directory & "/config/Routes.cfm" ) ) {
			include template=ext.directory & "/config/Routes.cfm";
		}
	} );

	addRouteHandler( getModel( dsl="delayedInjector:errorRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:adminRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:assetRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:plainStoredFileRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:staticAssetRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:emailRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:defaultPresideRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:restRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:standardRouteHandler" ) );
</cfscript>