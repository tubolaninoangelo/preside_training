<cfparam name="args.booker_details.firstname"       type="string" />
<cfparam name="args.booker_details.lastname"        type="string" />
<cfparam name="args.booker_details.event_title"     type="string" />
<cfparam name="args.booker_details.firstname"       type="string" />
<cfparam name="args.booker_details.lastname"        type="string" />
<cfparam name="args.booker_details.total_amount"    type="string" />
<cfparam name="args.booker_details.session"         type="string" />
<cfparam name="args.booker_details.special_request" type="string" />

<cfoutput>
	<i class="fa fa-fw fa-calendar-o"></i> An event has been booked: <strong>#args.booker_details.firstname# #args.booker_details.lastname#</strong>.
	With email address #args.booker_details.email#


	Event details

    Title
    #args.booker_details.event_title#

    Firstname
    #args.booker_details.firstname#

    Lastname
    #args.booker_details.lastname#

    Total amount
    #args.booker_details.total_amount#

    Session
    #args.booker_details.session#

    Special Request
    #args.booker_details.special_request#

</cfoutput>
