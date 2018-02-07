<cfscript>
	inputName    = args.name         ?: "";
	inputId      = args.id           ?: "";
	defaultValue = args.defaultValue ?: "";
	values       = args.values       ?: "";
	labels       = args.labels       ?: "";
	placeholder  = args.placeholder  ?: "";
	tabindex     = getNextTabIndex();

	if ( IsSimpleValue( values ) ) { values = ListToArray( values ); }
	if ( IsSimpleValue( labels ) ) { labels = ListToArray( labels ); }

	value = event.getValue( name=inputName, defaultValue=defaultValue );
	if ( not IsSimpleValue( value ) ) {
		value = "";
	}

	value = HtmlEditFormat( value );
	valueFound = false;

</cfscript>

<cfoutput>

	<select class="form-control"
            name="#inputName#"
            id="#inputId#"
            tabindex="#getNextTabIndex()#"
            data-placeholder=" "
            data-value="#value#">
        <option value="">Please select</option>
        <cfloop array="#values#" index="i" item="selectValue">
            <option value="#HtmlEditFormat( selectValue )#">
                #HtmlEditFormat( translateResource( labels[i] ?: "", labels[i] ?: "" ) )#
            </option>
        </cfloop>
    </select>

</cfoutput>