<cfscript>
	inputName      = args.name         ?: "";
	inputId        = args.id           ?: "";
	placeholder    = args.placeholder  ?: "";
	tabindex       = getNextTabIndex();
	seatsAvailable = args.seatsAvailable ?: "";

</cfscript>

<cfoutput>

	<cfif len( seatsAvailable )>
		<select class="form-control"
	            name="#inputName#"
	            id="#inputId#"
	            tabindex="#getNextTabIndex()#"
	            data-placeholder=" "
	            data-value="#value#">
	        <option value="">Please select</option>
	        <cfloop from="1" to="#seatsAvailable#" index="i">
	            <option value="#HtmlEditFormat( i )#">
	                #HtmlEditFormat( translateResource( v ?: "", i ?: "" ) )#
	            </option>
	        </cfloop>
	    </select>
	</cfif>

</cfoutput>