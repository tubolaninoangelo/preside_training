<cfscript>
    
</cfscript>

<cfoutput>
    <div class="form-group<cfif args.hasError> has-error</cfif><cfif NOT isEmpty( trim( args.formGroupClass ) )> #args.formGroupClass#</cfif> <cfif args.hidden ?: false == true >hidden</cfif>">

        <cfif NOT isEmpty( args.label ) && !(isBoolean( args.noLabel?:"" ) && args.noLabel)>
                
                <label for="#args.id#">
                    #args.label#<cfif args.required><span class="required">*</span></cfif>
                </label>


        </cfif>

        <div class="form-field #args.formFieldClass#">
            #args.control#

            <cfif args.hasError>
                <div class="alert alert-danger error">
                    #args.error#
                </div>
            </cfif>

            <cfif args.hasTooltip>
                <div class="tooltip-wrapper">
                    <a href="##" class="font-icon font-icon-tooltip information-icon js-show-tooltip" title="#args.tooltips#" data-position="top" ></a>
                    Supplementary information
                </div>
            </cfif>

            <cfif args.hasHelpText>
                <div class="tooltip-wrapper">
                    <a href="##" class="font-icon font-icon-tooltip information-icon js-show-tooltip" title="#args.help#" data-position="top" ></a>
                    Supplementary information
                </div>
            </cfif>
        </div>
    </div>
</cfoutput>