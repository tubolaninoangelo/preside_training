<cfscript>
	inputName    = args.name         ?: "";
	inputId      = args.id           ?: "";
	inputClass   = args.class        ?: "";
	readOnly   	 = args.readonly     ?: false;
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

	<input type="email" id="#inputId#" placeholder="#placeholder#" name="#inputName#" value="#value#" class="#inputClass# form-control" tabindex="#getNextTabIndex()#" <cfif readOnly>readonly</cfif> > <!---
	<label class="label" for="#inputId#">#args.args.label#</label> --->

</cfoutput>