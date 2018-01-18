<cfparam name="args.id"              type="string" />
<cfparam name="args._version_number" type="string" />

<cfset editRecordLink = event.buildAdminLink( linkTo="apiUserManager.edit", queryString="id=#args.id#&version=#args._version_number#" ) />

<cfoutput>
	<div class="action-buttons btn-group">
		<a href="#editRecordLink#" data-context-key="e" title="#HtmlEditFormat( translateResource( uri="cms:datatable.contextmenu.edit" ) )#">
			<i class="fa fa-pencil"></i>
		</a>
	</div>
</cfoutput>