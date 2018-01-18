/**
 * Handler for authenticating with token authentication
 *
 */
component {

	property name="authService" inject="presideRestAuthService";

	private string function authenticate() {
		var headers    = getHTTPRequestData().headers;
		var authHeader = headers.Authorization ?: "";
		var token      = "";

		try {
			authHeader = toString( toBinary( listRest( authHeader, ' ' ) ) );
			token      = ListFirst( authHeader, ":" );

			if ( !token.trim().len() ) {
				throw( type="missing.token" );
			}
		} catch( any e ) {
			return "";
		}

		return authService.getUserIdByToken( token );
	}

}