<cfparam name="args.video_url" 			default="" />
<cfparam name="args.video_title" 		default="" />
<cfparam name="args.video_description" 	default="" />
<cfparam name="args.video_dimension" 	default="" />

<cfscript>

	dimension       = listQualify(args.video_dimension, "x" );
	dimensionWidth  = dimension[1] ?: 240;
	dimensionHeight = dimension[2] ?: 240;

</cfscript>

<cfoutput>

	<cfif NOT isEmpty( args.video_title )>
		<h3>#args.video_title#</h3>
	</cfif>
	<cfif NOT isEmpty( args.video_url )>
		<iframe width="dimensionWidth" height="dimensionHeight" src="#args.video_url#" frameborder="0" allow="encrypted-media" allowfullscreen></iframe>
	</cfif>
	<cfif NOT isEmpty( args.video_description )>
		<p>#args.video_description#</p>
	</cfif>

</cfoutput>