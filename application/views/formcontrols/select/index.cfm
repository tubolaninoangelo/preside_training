<cfscript>
	inputName    = args.name         ?: "";
	inputId      = args.id           ?: "";
	defaultValue = args.defaultValue ?: "";
	values       = args.values       ?: [1,2,3,4,5,6,7,8,9,10];
	placeholder  = args.placeholder  ?: "";
	tabindex     = getNextTabIndex();

	value  = event.getValue( name=inputName, defaultValue=defaultValue );
	if ( not IsSimpleValue( value ) ) {
		value = "";
	}
	value = HtmlEditFormat( value );
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