<cfparam name="args.booker_details.firstname" type="string" />
<cfparam name="args.booker_details.lastname"  type="string" />
<cfparam name="args.booker_details.email"     type="string" />

<cfoutput>
	<i class="fa fa-fw fa-calendar-o"></i> An event has been booked: <strong>#args.booker_details.firstname# #args.booker_details.lastname#</strong>.
	With email address #args.booker_details.email#
</cfoutput>