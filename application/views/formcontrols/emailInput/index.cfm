<cfscript>
	inputName    = args.name         ?: "";
	inputId      = args.id           ?: "";
	inputClass   = args.class        ?: "";
	defaultValue = args.defaultValue ?: "";
	placeholder  = args.placeholder  ?: "";
	tabindex     = getNextTabIndex();

	value  = event.getValue( name=inputName, defaultValue=defaultValue );
	if ( not IsSimpleValue( value ) ) {
		value = "";
	}
	value = HtmlEditFormat( value );
</cfscript>

<cfoutput>
	<div class="form-group">
		<div class="form-field">
			<input type="text" id="#inputId#" placeholder="#placeholder#" name="#inputName#" value="#value#" class="#inputClass# form-control" tabindex="#getNextTabIndex()#"><!---
			<label class="label" for="#inputId#">#args.args.label#</label> --->
		</div>
	</div>
</cfoutput>