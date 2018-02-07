/**
 * Sticker bundle configuration file. See: http://sticker.readthedocs.org/
 */
component {

	public void function configure( bundle ) {

		bundle.addAssets(
			  directory   = "/"
			, match       = function( filepath ){ return ReFindNoCase( "\.(js|css)$", filepath ); }
			, idGenerator = function( filepath ){
				var fileName = ListLast( filePath, "/" );
				var id       = ListLast( filename, "." ) & "-" & ReReplace( filename, "\.(js|css)$", "" );
				return id;
			  }
		);

		bundle.addAssets(
              directory   = "/js/"
            , match       = function( filepath ){ return ReFindNoCase( "\.(js|css)$", filepath ); }
            , idGenerator = function( path ) {
                return ListDeleteAt( path, ListLen( path, "/" ), "/" ) & "/";
            }
        );

		bundle.asset( "css-bootstrap" ).before( "*" );
		bundle.asset( "js-bootstrap" ).dependsOn( "js-jquery" );
	}

}