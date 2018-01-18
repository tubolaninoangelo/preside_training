<cfscript>
	inputName    = args.name          ?: "";
	inputId      = args.id            ?: "";
	inputClass   = args.class         ?: "";
	defaultValue = args.defaultValue  ?: "";
	label        = args.label         ?: "";
	value        = event.getValue( name=inputName, defaultValue=defaultValue );


	if ( not IsSimpleValue( value ) ) {
		value = "";
	}
	value = HtmlEditFormat( value );

	checked = value == 1;
</cfscript>

<cfoutput>
    <div class="checkbox">
        <input type="checkbox" id="#inputId#" name="#inputName#" value="1" class="#inputClass#" tabindex="#getNextTabIndex()#" <cfif checked>checked</cfif> >
        <label for="#inputId#">#label#</label>

    </div>

</cfoutput>