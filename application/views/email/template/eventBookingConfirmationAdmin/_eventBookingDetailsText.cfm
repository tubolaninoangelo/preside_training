<cfscript>
	eventBookerDetail = args.eventBookingDetails ?: {};
</cfscript>
<cfoutput>
=====================
Event booker detail
=====================
Event title         : #eventBookerDetail.event_title     ?: ""#
Firstname           : #eventBookerDetail.firstname       ?: ""#
Lastname            : #eventBookerDetail.lastname        ?: ""#
Total amount        : #eventBookerDetail.total_amount    ?: ""#
Session             : #eventBookerDetail.session         ?: ""#
Special request     : #eventBookerDetail.special_request ?: ""#

</cfoutput>