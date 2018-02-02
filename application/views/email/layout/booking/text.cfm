<cfscript>
  param name="args.body"             type="string";
  param name="args.footer_plain"     type="string" default="";
</cfscript>

<cfoutput>
#Trim( args.body )#<cfif Len( Trim( args.footer_plain ) )>
#args.footer_plain#</cfif>
</cfoutput>