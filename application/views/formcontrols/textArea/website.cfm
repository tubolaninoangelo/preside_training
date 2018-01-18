<cfscript>
	inputName    = args.name         ?: "";
	inputId      = args.id           ?: "";
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
	<!--- TODO, your form control HTML here --->
	<textarea id="#inputId#" class="form-control" name="#inputName#" tabindex="#getNextTabIndex()#">#value#</textarea>

</cfoutput>