<cfparam name="args.action"            type="string" />
<cfparam name="args.known_as"          type="string" />
<cfparam name="args.userLink"          type="string" />
<cfparam name="args.record_id"         type="string" />

<cfscript>
	userLink    = '<a href="#args.userLink#">#args.known_as#</a>';
	recordLabel = renderLabel( "rest_user", args.record_id );
	recordUrl   = event.buildAdminLink( linkTo="apiUserManager.edit", queryString="id=#args.record_id#" );
	recordLink  = '<a href="#recordUrl#">#recordLabel#</a>';

	message = translateResource( uri="auditlog.apiManager:#args.action#.message", data=[ userLink, recordLink ] );
</cfscript>

<cfoutput>
	#message#
</cfoutput>