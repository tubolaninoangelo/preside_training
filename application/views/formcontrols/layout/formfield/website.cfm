<cfscript>
	param name="args.type"            type="string";
	param name="args.control"         type="string";
	param name="args.id"              type="string"  default="";
	param name="args.label"           type="string";
	param name="args.help"            type="string";
	param name="args.error"           type="string"  default="";
	param name="args.tooltips"        type="string"  default="";
	param name="args.required"        type="boolean" default="false";
	param name="args.formGroupClass"  type="string"  default="";
	param name="args.formFieldClass"  type="string"  default="";
	param name="args.noFormField"     type="boolean" default="false";

	args.tooltips = ( StructkeyExists( prc, args.name & "_tooltips" ) ) ? prc[ args.name & "_tooltips" ] : args.tooltips;

	args.hasError    = Len( Trim( args.error    ) );
	args.hasTooltip  = Len( Trim( args.tooltips ) );
	args.hasHelpText = Len( Trim( args.help     ) );
</cfscript>

<cfoutput>

	#renderView( view="/formcontrols/layout/formfield/_default", args=args )#

</cfoutput>
