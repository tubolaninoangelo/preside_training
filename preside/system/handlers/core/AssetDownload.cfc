component output=false {

	property name="assetManagerService"          inject="assetManagerService";
	property name="websiteUserActionService"     inject="websiteUserActionService";
	property name="rulesEngineWebRequestService" inject="rulesEngineWebRequestService";

	public function asset( event, rc, prc ) output=false {
		announceInterception( "preDownloadAsset" );

		_checkDownloadPermissions( argumentCollection=arguments );

		var assetId           = rc.assetId      ?: "";
		var versionId         = rc.versionId    ?: "";
		var derivativeName    = rc.derivativeId ?: "";
		var isTrashed         = IsTrue( rc.isTrashed ?: "" );
		var asset             = "";
		var assetSelectFields = [ "asset.title", "asset.is_trashed" ];
		var passwordProtected = false;

		try {
			if ( Len( Trim( derivativeName ) ) ) {
				arrayAppend( assetSelectFields , "asset_derivative.asset_type" );

				asset = assetManagerService.getAssetDerivative( assetId=assetId, versionId=versionId, derivativeName=derivativeName, selectFields=assetSelectFields );
			} else if( Len( Trim( versionId ) ) ) {
				arrayAppend( assetSelectFields , "asset_version.asset_type" );
				asset = assetManagerService.getAssetVersion( assetId=assetId, versionId=versionId, selectFields=assetSelectFields );
			} else {
				arrayAppend( assetSelectFields , "asset.asset_type" );
				asset = assetManagerService.getAsset( id=assetId, selectFields=assetSelectFields );
			}
		} catch ( "AssetManager.assetNotFound" e ) {
			asset = QueryNew('');
		} catch ( "AssetManager.versionNotFound" e ) {
			asset = QueryNew('');
		} catch ( "AssetManagerService.missingDerivativeConfiguration" e ) {
			if ( getSetting( name="showErrors", defaultValue=false ) ) {
				rethrow;
			}
			asset = QueryNew('');
		} catch ( "storageProvider.objectNotFound" e ) {
			asset = QueryNew('');
		} catch( "AssetManager.Password error" e ){
			asset = QueryNew('');
			passwordProtected = true;
		}

		try {
			if ( asset.recordCount && ( isTrashed == asset.is_trashed ) ) {
				var assetBinary = "";
				var type        = assetManagerService.getAssetType( name=asset.asset_type, throwOnMissing=true );
				var etag        = assetManagerService.getAssetEtag( id=assetId, versionId=versionId, derivativeName=derivativeName, throwOnMissing=true, isTrashed=isTrashed  );
				_doBrowserEtagLookup( etag );

				if ( Len( Trim( derivativeName ) ) ) {
					assetBinary = assetManagerService.getAssetDerivativeBinary( assetId=assetId, versionId=versionId, derivativeName=derivativeName );
				} else {
					assetBinary = assetManagerService.getAssetBinary( id=assetId, versionId=versionId, isTrashed=isTrashed );
				}

				announceInterception( "onDownloadAsset", {
					  assetId        = assetId
					, derivativeName = derivativeName
					, asset          = asset
				} );

				var filename = _getFilenameForAsset( asset.title, type.extension );
				if ( type.serveAsAttachment ) {
					websiteUserActionService.recordAction(
						  action     = "download"
						, type       = "asset"
						, userId     = getLoggedInUserId()
						, identifier = assetId
					);
					header name="Content-Disposition" value="attachment; filename=""#filename#""";
				} else {
					header name="Content-Disposition" value="inline; filename=""#filename#""";
				}

				header name="etag" value=etag;
				header name="cache-control" value="max-age=31536000";
				content
					reset    = true
					variable = assetBinary
					type     = type.mimeType;
				abort;
			} else if( passwordProtected ){
				assetBinary = fileReadBinary(event.buildLink( systemStaticAsset = "/images/asset-type-icons/48px/locked-pdf.png" ));
				header name="Content-Disposition" value="inline; filename=""ProctedPDF""";
				content
					reset    = true
					variable = assetBinary
					type     = 'png';
				abort;
			}
		} catch ( "storageProvider.objectNotFound" e ) {}

		event.renderData( data="404 not found", type="text", statusCode=404 );

	}

// private helpers
	private string function _doBrowserEtagLookup( required string etag ) output=false {
		if ( ( cgi.http_if_none_match ?: "" ) == arguments.etag ) {
			announceInterception( "onReturnAsset304", { etag = arguments.etag } );
			content reset=true;header statuscode=304 statustext="Not Modified";abort;
		}
	}

	private string function _getFilenameForAsset( required string assetTitle, required string extension ) {
		return ReReplace( arguments.assetTitle, "\.#arguments.extension#$", "" ) & "." & arguments.extension;
	}

	private void function _checkDownloadPermissions( event, rc, prc ) output=false {
		var assetId        = rc.assetId       ?: "";
		var derivativeName = rc.derivativeId  ?: "";

		if ( Len( Trim( derivativeName ) ) && assetManagerService.isDerivativePubliclyAccessible( derivativeName ) ) {
			return;
		}

		var permissionSettings = assetManagerService.getAssetPermissioningSettings( assetId );

		if ( permissionSettings.restricted ) {
			if ( Len( Trim( permissionSettings.conditionId ) ) ) {
				var conditionIsTrue = rulesEngineWebRequestService.evaluateCondition( permissionSettings.conditionId );

				if ( !conditionIsTrue ) {
					if ( !isLoggedIn() || ( permissionSettings.fullLoginRequired && isAutoLoggedIn() ) ) {
						event.accessDenied( reason="LOGIN_REQUIRED", postLoginUrl=( cgi.http_referer ?: "" ) );
					} else {
						event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
					}
				}
				return;
			}
			var hasPerm = event.isAdminUser() && hasCmsPermission(
				  permissionKey       = "assetmanager.assets.download"
				, context             = "assetmanagerfolder"
				, contextKeys         = permissionSettings.contextTree
				, forceGrantByDefault = IsBoolean( permissionSettings.grantAcessToAllLoggedInUsers ) && permissionSettings.grantAcessToAllLoggedInUsers
			);
			if ( hasPerm ) { return; }

			if ( !isLoggedIn() || ( permissionSettings.fullLoginRequired && isAutoLoggedIn() ) ) {
				event.accessDenied( reason="LOGIN_REQUIRED", postLoginUrl=( cgi.http_referer ?: "" ) );
			}

			hasPerm = hasWebsitePermission(
				  permissionKey       = "assets.access"
				, context             = "asset"
				, contextKeys         = permissionSettings.contextTree
				, forceGrantByDefault = IsBoolean( permissionSettings.grantAcessToAllLoggedInUsers ) && permissionSettings.grantAcessToAllLoggedInUsers
			)
			if ( !hasPerm ) {
				event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
			}
		}
	}
}