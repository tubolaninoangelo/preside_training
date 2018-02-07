<cfscript>
	inputName        = args.name             ?: "";
	inputId          = args.id               ?: "";
	inputClass       = args.class            ?: "";
	placeholder      = args.placeholder      ?: "";
	defaultValue     = args.defaultValue     ?: "";
	minDate          = args.minDate 	     ?: "";
	maxDate          = args.maxDate 	     ?: "";
	relativeToField  = args.relativeToField  ?: "";
	relativeOperator = args.relativeOperator ?: "";
	datePickerClass  = "formbuilder-date-picker"
	language         = event.isAdminRequest() ? getPlugin( "i18n" ).getFWLanguageCode() : ListFirst( event.getLanguageCode(), "-" );

	value  = event.getValue( name=inputName, defaultValue=defaultValue );
	if ( not IsSimpleValue( value ) ) {
		value = "";
	}
	if ( IsDate( value ) ) {
		value = DateFormat( value, "yyyy-mm-dd" );
	}

	startDate = "";
	endDate   = "";
	if ( IsDate( minDate ) ) {
		startDate = dateFormat( minDate ,"yyyy-mm-dd" );
	}
	if ( IsDate( maxDate ) ) {
		endDate = dateFormat( maxDate ,"yyyy-mm-dd" );
	}
	event.include('/js/specific/picker/');
</cfscript>

<cfoutput>
	<div class="form-group">
		<div class="form-field">
			<input name="#inputName#" placeholder="#placeholder#" class="#inputClass# form-control #datePickerClass# datepicker" id="#inputId#" type="text" data-relative-to-field="#relativeToField#" data-relative-operator="#relativeOperator#" data-date-format="yyyy-mm-dd" value="#HtmlEditFormat( value )#" tabindex="#getNextTabIndex()#"<cfif Len( Trim( startDate ) )> data-start-date="#startDate#"</cfif><cfif Len( Trim( endDate ) )> data-end-date="#endDate#"</cfif> autocomplete="off" data-language="#language#" />
			<label class="label" for="#inputId#">#args.label#</label>
		</div>
	</div>
</cfoutput>