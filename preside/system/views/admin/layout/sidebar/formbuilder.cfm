<cfscript>
	if ( isFeatureEnabled( "formbuilder" ) && hasCmsPermission( "formbuilder.navigate" ) ) {
		writeOutput( renderView(
			  view = "/admin/layout/sidebar/_menuItem"
			, args = {
				  active  = ListLast( event.getCurrentHandler(), ".") eq "formbuilder"
				, link    = event.buildAdminLink( linkTo="formbuilder" )
				, gotoKey = "f"
				, icon    = "fa-check-square-o"
				, title   = translateResource( 'formbuilder:admin.menu.title' )
			  }
		) );
	}
</cfscript>