/**
 *	Helper methods and standard event method overrides that are specific to Preside
 *	live here.
 */
component extends="coldbox.system.web.context.RequestContextDecorator" output=false {

/*
 * NOTE: Because this CFC is merged with a tag based CFC file
 * the output=false declarations on all the functions are all *necessary*!
 * Do not remove them unless you are fully aware that this issue is no
 * longer a problem.
 *
 * Dominic
 *
 */

// URL related
	public void function setSite( required struct site ) output=false {
		getModel( "tenancyService" ).setTenantId( tenant="site", id=( site.id ?: "" ) );
		getRequestContext().setValue(
			  name    = "_site"
			, value   =  arguments.site
			, private =  true
		);
	}

	public struct function getSite() output=false {
		var site = getRequestContext().getValue( name="_site", private=true, defaultValue={} );

		if ( IsStruct( site ) ) {
			return site;
		}

		return {};
	}

	public string function getSiteUrl( string siteId="", boolean includePath=true, boolean includeLanguageSlug=true ) output=false {
		var prc       = getRequestContext().getCollection( private=true );
		var fetchSite = ( prc._forceDomainLookup ?: false ) || ( Len( Trim( arguments.siteId ) ) && arguments.siteId != getSiteId() );
		var site      = fetchSite ? getModel( "siteService" ).getSite( arguments.siteId ) : getSite();
		var siteUrl   = ( site.protocol ?: "http" ) & "://" & ( fetchSite ? ( site.domain ?: cgi.server_name ) : cgi.server_name );

		prc.delete( "_forceDomainLookup" );

		if ( !listFindNoCase( "80,443", cgi.SERVER_PORT ) ) {
			siteUrl &= ":#cgi.SERVER_PORT#";
		}

		if ( arguments.includePath ) {
			siteUrl &= site.path ?: "/";
		}

		if ( arguments.includeLanguageSlug ) {
			var languageSlug = this.getLanguageSlug();
			if ( Len( Trim( languageSlug ) ) ) {
				siteUrl = ReReplace( siteUrl, "/$", "" ) & "/" & languageSlug;
			}
		}

		siteUrl = siteUrl.reReplace( "/$", "" );

		return siteUrl;
	}

	public string function getSystemPageId( required string systemPage ) output=false {
		var sitetreeSvc = getModel( "sitetreeService" );
		var page        = sitetreeSvc.getPage(
			  systemPage   = arguments.systemPage
				, selectFields = [ "id" ]
		);

		if ( not page.recordCount ) {
			return "";
		}
		return page.id;
	}

	public string function getSiteId() output=false {
		var site = getSite();

		return site.id ?: "";
	}

	public string function buildLink( string siteId="", string queryString="" ) output=false {
		var prc = getRequestContext().getCollection( private=true );

		if ( arguments.siteId.len() ) {
			arguments.queryString = ListPrepend( arguments.queryString, "_sid=" & arguments.siteId, "&" );
		}

		announceInterception(
			  state         = "onBuildLink"
			, interceptData = arguments
		);

		var link = prc._builtLink ?: "";
		StructDelete( prc, "_builtLink" );

		if ( not Len( Trim( link ) ) and Len( Trim( arguments.linkTo ?: "" ) ) ) {
			link = getRequestContext().buildLink( argumentCollection = arguments );
		}

		return link;
	}

	public string function getProtocol() output=false {
		return ( cgi.https ?: "" ) == "on" ? "https" : "http";
	}

	public string function getServerName() output=false {
		return cgi.server_name;
	}

	public string function getBaseUrl() output=false {
		return getProtocol() & "://" & getServerName() & ( !listFindNoCase( "80,443", cgi.SERVER_PORT ) ? ":" & cgi.SERVER_PORT : "" );
	}

	public string function getCurrentUrl( boolean includeQueryString=true ) output=false {
		var currentUrl  = request[ "preside.path_info"    ] ?: "";
		var qs          = request[ "preside.query_string" ] ?: "";
		var includeQs   = arguments.includeQueryString && Len( Trim( qs ) );

		return includeQs ? currentUrl & "?" & qs : currentUrl;
	}

	public void function setCurrentPresideUrlPath( required string presideUrlPath ) {
		getRequestContext().setValue( name="_presideUrlPath", private=true, value=arguments.presideUrlPath );
	}

	public string function getCurrentPresideUrlPath() {
		return getRequestContext().getValue( name="_presideUrlPath", private=true, defaultValue="/" );
	}

// REQUEST DATA
	public struct function getCollectionWithoutSystemVars() output=false {
		var collection = Duplicate( getRequestContext().getCollection() );

		StructDelete( collection, "csrfToken"   );
		StructDelete( collection, "action"      );
		StructDelete( collection, "event"       );
		StructDelete( collection, "handler"     );
		StructDelete( collection, "module"      );
		StructDelete( collection, "fieldnames"  );

		return collection;
	}

	public struct function getCollectionForForm(
		  string  formName                = ""
		, boolean stripPermissionedFields = true
		, string  permissionContext       = ""
		, array   permissionContextKeys   = []
		, string  fieldNamePrefix         = ""
		, string  fieldNameSuffix         = ""
	) output=false {
		var formNames    = Len( Trim( arguments.formName ) ) ? [ arguments.formName ] : this.getSubmittedPresideForms();
		var formsService = getModel( "formsService" );
		var rc           = getRequestContext().getCollection();
		var collection   = {};

		for( var name in formNames ) {
			var formFields = formsService.listFields( argumentCollection=arguments, formName=name );
			for( var field in formFields ){
				var fieldName = arguments.fieldNamePrefix & field & arguments.fieldNameSuffix;
				collection[ field ] = ( rc[ fieldName ] ?: "" );
			}
		}

		return collection;
	}

	public array function getSubmittedPresideForms() output=false {
		var rc = getRequestContext().getCollection();

		return ListToArray( Trim( rc[ "$presideform" ] ?: "" ) );
	}

// Admin specific
	public string function buildAdminLink( string linkTo="", string queryString="", string siteId=this.getSiteId() ) output=false {
		arguments.linkTo = ListAppend( "admin", arguments.linkTo, "." );

		if ( isActionRequest( arguments.linkTo ) ) {
			arguments.queryString = ListPrepend( arguments.queryString, "csrfToken=" & this.getCsrfToken(), "&" );
		}

		return buildLink( argumentCollection = arguments );
	}

	public string function getAdminPath() output=false {
		var path = getController().getSetting( "preside_admin_path" );

		return Len( Trim( path ) ) ? "/#path#/" : "/";
	}

	public boolean function isAdminRequest() output=false {
		var currentUrl = getCurrentUrl();
		var adminPath  = getAdminPath();

		return currentUrl.startsWith( adminPath );
	}

	public boolean function isAdminUser() output=false {
		var loginSvc = getModel( "loginService" );

		return loginSvc.isLoggedIn();
	}

	public boolean function showNonLiveContent() output=false {
		if ( this.isAdminRequest() ) {
			return true;
		}

		return getModel( "loginService" ).isShowNonLiveEnabled();
	}

	public struct function getAdminUserDetails() output=false {
		return getModel( "loginService" ).getLoggedInUserDetails();
	}

	public string function getAdminUserId() output=false {
		return getModel( "loginService" ).getLoggedInUserId();
	}

	public void function adminAccessDenied() output=false {
		var event = getRequestContext();

		announceInterception( "onAccessDenied" , arguments );

		event.setView( view="/admin/errorPages/accessDenied" );

		event.setHTTPHeader( statusCode="401" );
		event.setHTTPHeader( name="X-Robots-Tag"    , value="noindex" );
		event.setHTTPHeader( name="WWW-Authenticate", value='Website realm="website"' );

		content reset=true type="text/html";header statusCode="401";WriteOutput( getController().getPlugin("Renderer").renderLayout() );abort;
	}

	public void function audit( userId=getAdminUserId() ) output=false {
		return getModel( "AuditService" ).log( argumentCollection = arguments );
	}

	public void function addAdminBreadCrumb( required string title, required string link ) output=false {
		var event  = getRequestContext();
		var crumbs = event.getValue( name="_adminBreadCrumbs", defaultValue=[], private=true );

		ArrayAppend( crumbs, { title=arguments.title, link=arguments.link } );

		event.setValue( name="_adminBreadCrumbs", value=crumbs, private=true );
	}

	public array function getAdminBreadCrumbs() output=false {
		return getRequestContext().getValue( name="_adminBreadCrumbs", defaultValue=[], private=true );
	}

	public string function getHTTPContent() output=false {
		return request.http.body ?: ToString( getHTTPRequestData().content );
	}

// Sticker
	public any function include() output=false {
		return _getSticker().include( argumentCollection = arguments );
	}

	public any function includeData() output=false {
		return _getSticker().includeData( argumentCollection = arguments );
	}

	public string function renderIncludes( string type, string group="default" ) output=false {
		var rendered      = _getSticker().renderIncludes( argumentCollection = arguments );

		if ( !arguments.keyExists( "type" ) || arguments.type == "js" ) {
			var inlineJs = getRequestContext().getValue( name="__presideInlineJs", defaultValue={}, private=true );
			var stack    = inlineJs[ arguments.group ] ?: [];

			rendered &= ArrayToList( stack, Chr(10) );

			inlineJs[ arguments.group ] = [];

			getRequestContext().setValue( name="__presideInlineJs", value=inlineJs, private=true );
		}

		return rendered;
	}

	public void function includeInlineJs( required string js, string group="default" ) output=false {
		var inlineJs = getRequestContext().getValue( name="__presideInlineJs", defaultValue={}, private=true );

		inlineJs[ arguments.group ] = inlineJs[ arguments.group ] ?: [];
		inlineJs[ arguments.group ].append( "<script type=""text/javascript"">" & Chr(10) & arguments.js & Chr(10) & "</script>" );

		getRequestContext().setValue( name="__presideInlineJs", value=inlineJs, private=true );
	}

// private helpers
	private any function _simpleRequestCache( required string key, required any generator ) output=false {
		request._simpleRequestCache = request._simpleRequestCache ?: {};

		if ( !request._simpleRequestCache.keyExists( arguments.key ) ) {
			request._simpleRequestCache[ arguments.key ] = arguments.generator();
		}

		return request._simpleRequestCache[ arguments.key ];
	}

	public any function _getSticker() output=false {
		return getController().getPlugin(
			  plugin       = "StickerForPreside"
			, customPlugin = true
		);
	}

	public any function getModel( required string beanName ) output=false {
		var singletons = [ "siteService", "sitetreeService", "formsService", "systemConfigurationService", "loginService", "AuditService", "csrfProtectionService", "websiteLoginService", "websitePermissionService", "multilingualPresideObjectService", "tenancyService" ];

		if ( singletons.findNoCase( arguments.beanName ) ) {
			var args = arguments;
			return _simpleRequestCache( "getSingleton" & arguments.beanName, function(){
				return getController().getWireBox().getInstance( args.beanName );
			} );
		}

		return getController().getWireBox().getInstance( arguments.beanName );
	}

	public any function announceInterception() output=false {
		return getController().getInterceptorService().processState( argumentCollection=arguments );
	}

// security helpers
	public string function getCsrfToken() output=false {
		return getModel( "csrfProtectionService" ).generateToken( argumentCollection = arguments );
	}

	public string function validateCsrfToken() output=false {
		return getModel( "csrfProtectionService" ).validateToken( argumentCollection = arguments );
	}

	public boolean function isActionRequest( string ev=getRequestContext().getCurrentEvent() ) output=false {
		var currentEvent = LCase( arguments.ev );

		if ( ReFind( "^admin\.ajaxProxy\..*?", currentEvent ) ) {
			currentEvent = "admin." & LCase( event.getValue( "action", "" ) );
		}

		return ReFind( "^admin\..*?action$", currentEvent );
	}

	public boolean function isStatelessRequest() {
		var appSettings = GetApplicationSettings();

		return IsBoolean( appSettings.statelessRequest ?: "" ) && appSettings.statelessRequest;
	}

	public void function setXFrameOptionsHeader( string value ) {
		if ( !StructKeyExists( arguments, "value" ) ) {
			var setting = getPageProperty( propertyName="iframe_restriction", cascading=true );
			switch( setting ) {
				case "allow":
					return; // do not set any header
				case "sameorigin":
					arguments.value = "SAMEORIGIN";
					break;
				default:
					arguments.value = "DENY";
			}
		}

		this.setHTTPHeader( name="X-Frame-Options", value=arguments.value, overwrite=true );
	}

// FRONT END, dealing with current page
	public void function initializePresideSiteteePage (
		  string  slug
		, string  pageId
		, string  systemPage
		, string  subaction
	) output=false {
		var sitetreeSvc = getModel( "sitetreeService" );
		var rc          = getRequestContext().getCollection();
		var prc         = getRequestContext().getCollection( private = true );
		var allowDrafts = this.showNonLiveContent();
		var getLatest   = allowDrafts;
		var page        = "";
		var parentPages = "";
		var getPageArgs = {};
		var isActive    = function( required boolean active, required string embargo_date, required string expiry_date ) {
			return arguments.active && ( !IsDate( arguments.embargo_date ) || Now() >= arguments.embargo_date ) && ( !IsDate( arguments.expiry_date ) || Now() <= arguments.expiry_date );
		}

		if ( ( arguments.slug ?: "/" ) == "/" && !Len( Trim( arguments.pageId ?: "" ) ) && !Len( Trim( arguments.systemPage ?: "" ) ) ) {
			page = sitetreeSvc.getSiteHomepage( getLatest=getLatest, allowDrafts=allowDrafts );
			parentPages = QueryNew( page.columnlist );
		} else {
			if ( Len( Trim( arguments.pageId ?: "" ) ) ) {
				getPageArgs.id = arguments.pageId;
			} else if ( Len( Trim( arguments.systemPage ?: "" ) ) ) {
				getPageArgs.systemPage = arguments.systemPage;
			} else {
				getPageArgs.slug = arguments.slug;
			}
			page = sitetreeSvc.getPage( argumentCollection=getPageArgs, getLatest=getLatest, allowDrafts=allowDrafts );
		}

		if ( !page.recordCount ) {
			return;
		}

		for( p in page ){ page = p; break; } // quick query row to struct hack

		StructAppend( page, sitetreeSvc.getExtendedPageProperties( id=page.id, pageType=page.page_type, getLatest=getLatest, allowDrafts=allowDrafts ) );
		var ancestors = sitetreeSvc.getAncestors( id = page.id );
		page.ancestors = [];

		page.ancestorList = ancestors.recordCount ? ValueList( ancestors.id ) : "";
		page.permissionContext = [ page.id ];
		for( var i=ListLen( page.ancestorList ); i > 0; i-- ){
			page.permissionContext.append( ListGetAt( page.ancestorList, i ) );
		}

		clearBreadCrumbs();
		for( var ancestor in ancestors ) {
			addBreadCrumb( title=ancestor.title, link=buildLink( page=ancestor.id ), menuTitle=ancestor.navigation_title ?: "" );
			page.ancestors.append( ancestor );
		}
		addBreadCrumb( title=page.title, link=buildLink( page=page.id ), menuTitle=page.navigation_title ?: "" );

		page.isInDateAndActive = isActive( argumentCollection = page );
		if ( page.isInDateAndActive ) {
			for( var ancestor in page.ancestors ) {
				page.isInDateAndActive = isActive( argumentCollection = ancestor );
				if ( !page.isInDateAndActive ) {
					break;
				}
			}
		}

		p[ "slug" ] = p._hierarchy_slug;
		StructDelete( p, "_hierarchy_slug" );

		prc.presidePage = page;
	}

	public void function initializeDummyPresideSiteTreePage() output=false {
		var sitetreeSvc = getModel( "sitetreeService" );
		var rc          = getRequestContext().getCollection();
		var prc         = getRequestContext().getCollection( private = true );
		var page        = Duplicate( arguments );
		var parentPages = "";

		page.ancestors = [];

		clearBreadCrumbs();

		if ( !IsNull( arguments.parentpage ?: NullValue() ) && arguments.parentPage.recordCount ) {
			page.parent_page = arguments.parentPage.id;

			var ancestors = sitetreeSvc.getAncestors( id = arguments.parentPage.id );

			page.ancestorList = ancestors.recordCount ? ValueList( ancestors.id ) : "";
			page.ancestorList = ListAppend( page.ancestorList, arguments.parentPage.id );

			page.permissionContext = [];
			for( var i=ListLen( page.ancestorList ); i > 0; i-- ){
				page.permissionContext.append( ListGetAt( page.ancestorList, i ) );
			}

			for( var ancestor in ancestors ) {
				addBreadCrumb( title=ancestor.title, link=buildLink( page=ancestor.id ), menuTitle=ancestor.navigation_title ?: "" );
				page.ancestors.append( ancestor );
			}

			for( var p in arguments.parentPage ){
				addBreadCrumb( title=p.title, link=buildLink( page=p.id ), menuTitle=p.navigation_title ?: "" );
				page.ancestors.append( p );
			}
		}

		addBreadCrumb( title=page.title ?: "", link=getCurrentUrl(), menuTitle=page.navigation_title ?: "" );

		prc.presidePage = page;
	}

	public void function checkPageAccess() output=false {
		var websiteLoginService = getModel( "websiteLoginService" );
		var accessRules         = getPageAccessRules();

		if ( accessRules.access_restriction == "full" || accessRules.access_restriction == "partial" ){
			var fullLoginRequired = IsBoolean( accessRules.full_login_required ) && accessRules.full_login_required;
			var loggedIn          = websiteLoginService.isLoggedIn() && (!fullLoginRequired || !websiteLoginService.isAutoLoggedIn() );

			if ( Len( Trim( accessRules.access_condition ) ) ) {
				var conditionIsTrue = getModel( "rulesEngineWebRequestService" ).evaluateCondition( accessRules.access_condition );

				if ( !conditionIsTrue ) {
					if ( !loggedIn ) {
						accessRules.access_restriction == "full" ? accessDenied( reason="LOGIN_REQUIRED" ) : this.setPartiallyRestricted( true );
					} else {
						accessRules.access_restriction == "full" ? accessDenied( reason="INSUFFICIENT_PRIVILEGES" ) : this.setPartiallyRestricted( true );
					}
				}
			} else {
				if ( !loggedIn ) {
					accessRules.access_restriction == "full" ? accessDenied( reason="LOGIN_REQUIRED" ) : this.setPartiallyRestricted( true );
				}

				hasPermission = getModel( "websitePermissionService" ).hasPermission(
					  permissionKey       = "pages.access"
					, context             = "page"
					, contextKeys         = [ accessRules.access_defining_page ]
					, forceGrantByDefault = IsBoolean( accessRules.grantaccess_to_all_logged_in_users ) && accessRules.grantaccess_to_all_logged_in_users
				);

				if ( !hasPermission ) {
					accessRules.access_restriction == "full" ? accessDenied( reason="INSUFFICIENT_PRIVILEGES" ) : this.setPartiallyRestricted( true );
				}
			}
		}
	}

	public struct function getPageAccessRules() output=false {
		var prc = getRequestContext().getCollection( private = true );

		if ( !prc.keyExists( "pageAccessRules" ) ) {
			prc.pageAccessRules = getModel( "sitetreeService" ).getAccessRestrictionRulesForPage( getCurrentPageId() );
		}

		return prc.pageAccessRules;
	}

	public void function setPartiallyRestricted( required boolean isRestricted ) {
		var prc = getRequestContext().getCollection( private = true );

		prc.isPartiallyRestricted = arguments.isRestricted;
	}

	public boolean function isPagePartiallyRestricted() {
		var prc = getRequestContext().getCollection( private = true );

		return IsBoolean( prc.isPartiallyRestricted ?: "" ) && prc.isPartiallyRestricted;
	}

	public void function preventPageCache() output=false {
		header name="cache-control" value="no-cache, no-store";
		header name="expires"       value="Fri, 20 Nov 2015 00:00:00 GMT";
	}

	public boolean function canPageBeCached() output=false {
		if ( getModel( "websiteLoginService" ).isLoggedIn() || this.isAdminUser() ) {
			return false;
		}

		var accessRules = getPageAccessRules();

		return ( accessRules.access_restriction ?: "none" ) == "none";
	}

	public any function getPageProperty (
		  required string  propertyName
		,          any     defaultValue     = ""
		,          boolean cascading        = false
		,          string  cascadeMethod    = "closest"
		,          string  cascadeSkipValue = "inherit"
	) output=false {

		var page = getRequestContext().getValue( name="presidePage", defaultValue=StructNew(), private=true );

		if ( StructIsEmpty( page ) ) {
			return arguments.defaultValue;
		}

		if ( IsBoolean( page.isApplicationPage ?: "" ) && page.isApplicationPage ) {
			if ( arguments.cascading ) {
				var cascadeSearch = Duplicate( page.ancestors ?: [] );
				cascadeSearch.prepend( page );

				if ( arguments.cascadeMethod == "collect" ) {
					var collected = [];
				}
				for( node in cascadeSearch ){
					if ( Len( Trim( node[ arguments.propertyName ] ?: "" ) ) && node[ arguments.propertyName ] != arguments.cascadeSkipValue ) {
						if ( arguments.cascadeMethod != "collect" ) {
							return node[ arguments.propertyName ];
						}
						collected.append( node[ arguments.propertyName ] );
					}
				}

				if ( arguments.cascadeMethod == "collect" ) {
					return collected;
				}

				return arguments.defaultValue;
			}

			return page[ arguments.propertyName ] ?: arguments.defaultValue;
		}

		return getModel( "sitetreeService" ).getPageProperty(
			  propertyName  = arguments.propertyName
			, page          = page
			, ancestors     = page.ancestors ?: []
			, defaultValue  = arguments.defaultValue
			, cascading     = arguments.cascading
			, cascadeMethod = arguments.cascadeMethod
		);
	}

	public string function getCurrentPageType() output=false {
		return getPageProperty( 'page_type' );
	}

	public string function getCurrentTemplate() output=false {
		return getPageProperty( 'page_template' );
	}

	public string function getCurrentPageId() output=false {
		return getPageProperty( 'id' );
	}

	public boolean function isCurrentPageActive() output=false {
		return getPageProperty( 'isInDateAndActive', false );
	}

	public array function getPagePermissionContext() output=false {
		return getPageProperty( "permissionContext", [] );
	}

	public void function addBreadCrumb( required string title, required string link, string menuTitle="" ) output=false {
		var crumbs = getBreadCrumbs();

		ArrayAppend( crumbs, {
			  title     = arguments.title
			, link      = arguments.link
			, menuTitle = arguments.menuTitle.len() ? arguments.menuTitle : arguments.title
		} );

		getRequestContext().setValue( name="_breadCrumbs", value=crumbs, private=true );
	}

	public array function getBreadCrumbs() output=false {
		return getRequestContext().getValue( name="_breadCrumbs", defaultValue=[], private=true );
	}

	public void function clearBreadCrumbs() output=false {
		getRequestContext().setValue( name="_breadCrumbs", value=[], private=true );
	}

	public string function getEditPageLink() output=false {
		var prc = getRequestContext().getCollection( private=true );

		if ( !prc.keyExists( "_presideCmsEditPageLink" ) ) {
			setEditPageLink( buildAdminLink( linkTo='sitetree.editPage', queryString='id=#getCurrentPageId()#' ) );
		}

		return prc._presideCmsEditPageLink;
	}
	public void function setEditPageLink( required string editPageLink ) output=false {
		getRequestContext().setValue( name="_presideCmsEditPageLink", value=arguments.editPageLink, private=true );
	}

// FRONT END - Multilingual helpers
	public string function getLanguage() output=false {
		return getRequestContext().getValue( name="_language", defaultValue="", private=true );
	}
	public void function setLanguage( required string language ) output=false {
		getRequestContext().setValue( name="_language", value=arguments.language, private=true );
		getModel( "multilingualPresideObjectService" ).persistUserLanguage( arguments.language );
	}

	public string function getLanguageSlug() output=false {
		return getRequestContext().getValue( name="_languageSlug", defaultValue="", private=true );
	}
	public void function setLanguageSlug( required string languageSlug ) output=false {
		getRequestContext().setValue( name="_languageSlug", value=arguments.languageSlug, private=true );
	}

	public string function getLanguageCode() output=false {
		return getRequestContext().getValue( name="_languageCode", defaultValue="en", private=true );
	}
	public void function setLanguageCode( required string languageCode ) output=false {
		getRequestContext().setValue( name="_languageCode", value=arguments.languageCode, private=true );
	}

// HTTP Header helpers
	public string function getClientIp() output=false {
		var httpHeaders = getHttpRequestData().headers;
		var clientIp    = httpHeaders[ "x-real-ip" ] ?: ( httpHeader[ "x-forwarded-for"] ?: cgi.remote_addr );

		return Trim( ListFirst( clientIp ) );
	}

	public string function getUserAgent() output=false {
		return cgi.http_user_agent;
	}

	function setHTTPHeader( string statusCode, string statusText="", string name, string value="", boolean overwrite=false ){
		if ( StructKeyExists( arguments, "statusCode" ) ) {
			getPageContext().getResponse().setStatus( javaCast( "int", arguments.statusCode ), javaCast( "string", arguments.statusText ) );
		} else if ( StructKeyExists( arguments, "name" ) ) {
			if ( arguments.overwrite ) {
				getPageContext().getResponse().setHeader( javaCast( "string", arguments.name ), javaCast( "string", arguments.value ) );
			} else {
				getPageContext().getResponse().addHeader( javaCast( "string", arguments.name ), javaCast( "string", arguments.value ) );
			}
		} else {
			throw( message="Invalid header arguments",
				  detail="Pass in either a statusCode or name argument",
				  type="RequestContext.InvalidHTTPHeaderParameters" );
		}

		return this;
	}

// status codes
	public void function notFound() output=false {
		announceInterception( "onNotFound" );
		getController().runEvent( "general.notFound" );
		content reset=true type="text/html";header statusCode="404";WriteOutput( getController().getPlugin("Renderer").renderLayout() );abort;
	}

	public void function accessDenied( required string reason ) output=false {
		announceInterception( "onAccessDenied" , arguments );
		getController().runEvent( event="general.accessDenied", eventArguments={ args=arguments }, private=true );
		WriteOutput( getController().getPlugin("Renderer").renderLayout() );abort;
	}

// private helpers
	public string function _structToQueryString( required struct inputStruct ) output=false {
		var qs    = "";
		var delim = "";

		for( var key in inputStruct ){
			if ( IsSimpleValue( inputStruct[ key ] ) ) {
				qs &= delim & key & "=" & inputStruct[ key ];
				delim = "&";
			}
		}

		return qs;
	}
}