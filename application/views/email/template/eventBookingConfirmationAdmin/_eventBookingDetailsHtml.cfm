<cfscript>
	eventBookerDetail = args.eventBookingDetails ?: {};
</cfscript>
<cfoutput>

	<dl>
		<dt><b>Title</b></dt>
		<dd>#eventBookerDetail.event_title ?: ""#</dd>

		<dt><b>Firstname</b></dt>
		<dd>#eventBookerDetail.firstname ?: ""#</dd>

		<dt><b>Lastname</b></dt>
		<dd>#eventBookerDetail.lastname ?: ""#</dd>

		<dt><b>Total amount</b></dt>
		<dd>#eventBookerDetail.total_amount ?: ""#</dd>

		<dt><b>Session</b></dt>
		<dd>#eventBookerDetail.session ?: ""#</dd>

		<dt><b>Special Request</b></dt>
		<dd>#eventBookerDetail.special_request ?: ""#</dd>

	</dl>

</cfoutput>