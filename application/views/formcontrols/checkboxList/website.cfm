<cfscript>
	inputName      = args.name            ?: "";
	inputId        = args.id              ?: "";
	inputClass     = args.class           ?: "";
	values         = args.values          ?: "";
	defaultValue   = args.defaultValue    ?: "";
	extraClasses   = args.extraClasses    ?: "";
	labels         = len( args.labels )   ?  args.labels : args.values;

	if ( IsSimpleValue( values ) ) { values = ListToArray( values ); }
	if ( IsSimpleValue( labels ) ) { labels = ListToArray( labels ); }

	value  = event.getValue( name=inputName, defaultValue=defaultValue );
	if ( not IsSimpleValue( value ) ) {
		value = "";
	}

	value = HtmlEditFormat( value );
	valueFound = false;
</cfscript>

<cfoutput>
	<div class="two-columns">
		<cfloop array="#values#" index="i" item="selectValue">
			<cfset checked   = ListFindNoCase( value, selectValue ) />
			<cfset valueFound = valueFound || checked />

			<div class="checkbox">
				<input type="checkbox" id="#inputId#_#i#" name="#inputName#" value="#HtmlEditFormat( selectValue )#" class="#inputClass# #extraClasses#" tabindex="#getNextTabIndex()#" <cfif checked>checked</cfif>>
				<label for="#inputId#_#i#">#labels[i]#</label>
			</div>
		</cfloop>
	</div>
</cfoutput>