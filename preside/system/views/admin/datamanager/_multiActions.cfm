<cfscript>
	param name="args.objectName"          type="string";
	param name="args.batchEditableFields" type="array"   default=[];

	objectTitle          = translateResource( uri="preside-objects.#args.objectName#:title", defaultValue=args.objectName );
	batchEditTitle       = translateResource( uri="cms:datamanager.batchEditSelected.title" );
	deleteSelected       = translateResource( uri="cms:datamanager.deleteSelected.title" );
	deleteSelectedPrompt = translateResource( uri="cms:datamanager.deleteSelected.prompt", data=[ objectTitle ] );
</cfscript>
<cfoutput>
	<cfif args.batchEditableFields.len()>
		<div class="btn-group batch-update-menu">
			<button data-toggle="dropdown" class="btn btn-info">
				<span class="fa fa-caret-down"></span>
				<i class="fa fa-pencil"></i>
				#batchEditTitle#
			</button>

			<ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
				<li><h5 class="instructions">#translateResource( uri="cms:datamanager.batchedit.choose.field")#</h5></li>
				<cfloop array="#args.batchEditableFields#" index="i" item="field">
					<li data-field="#HtmlEditFormat( field )#" class="field">
						<a href="##">
							<i class="fa fa-fw fa-pencil"></i>&nbsp;
							#translateResource( uri="preside-objects.#args.objectName#:field.#field#.title", defaultValue=field )#
						</a>
					</li>
				</cfloop>
			</ul>
		</div>
	</cfif>
	<cfif hasCmsPermission( permissionKey="datamanager.delete", context="datamanager", contextKeys=[ args.objectName ] )>
		<button class="btn btn-danger confirmation-prompt" type="submit" name="delete" disabled="disabled" data-global-key="d" title="#deleteSelectedPrompt#">
			<i class="fa fa-trash-o bigger-110"></i>
			#deleteSelected#
		</button>
	</cfif>
</cfoutput>