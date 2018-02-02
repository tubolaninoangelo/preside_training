<cfparam name="args.booker_details.firstname"       type="string" />
<cfparam name="args.booker_details.lastname"        type="string" />
<cfparam name="args.booker_details.event_title"     type="string" />
<cfparam name="args.booker_details.firstname"       type="string" />
<cfparam name="args.booker_details.lastname"        type="string" />
<cfparam name="args.booker_details.total_amount"    type="string" />
<cfparam name="args.booker_details.session"         type="string" />
<cfparam name="args.booker_details.special_request" type="string" />

<cfoutput>
	<i class="fa fa-fw fa-calendar-o"></i> An event has been booked: <strong>#args.booker_details.firstname ?: ""# #args.booker_details.lastname ?: ""#</strong>.
	With email address #args.booker_details.email#

	<div class="well">

		<h4 class="green">Event details</h4>

		<dl class="dl-horizontal">
            <dt><b>Title</b></dt>
            <dd>#args.booker_details.event_title ?: ""#</dd>

            <dt><b>Firstname</b></dt>
            <dd>#args.booker_details.firstname ?: ""#</dd>

            <dt><b>Lastname</b></dt>
            <dd>#args.booker_details.lastname ?: ""#</dd>

            <dt><b>Total amount</b></dt>
            <dd>#args.booker_details.total_amount ?: ""#</dd>

            <dt><b>Session</b></dt>
            <dd>#args.booker_details.session ?: ""#</dd>

            <dt><b>Special Request</b></dt>
            <dd>#args.booker_details.special_request ?: ""#</dd>
		</dl>

	</div>

</cfoutput>

