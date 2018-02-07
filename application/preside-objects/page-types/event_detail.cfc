/**
 * @showInSiteTree          false
 * @allowedParentPageTypes  events
 * @allowedChildPageTypes   none
 */

component  {
	property name="event_startdate" type="datetime" dbtype="datetime" required=true;
	property name="event_enddate" 	type="datetime" dbtype="datetime" required=true;

	property name="event_document"  relationship="many-to-one"  relatedTo="asset";
	property name="region" 			relationship="many-to-many" relatedTo="region" 		relatedvia="event_detail_region";
	property name="category" 		relationship="many-to-one" 	relatedTo="category";
	property name="programmes"  	relationship="one-to-many" 	relatedTo="programme"	relationshipkey="event_detail";

	// Event booking
	property name="event_bookable"  type="boolean" 	dbtype="boolean";
	property name="event_price" 	type="int" 		dbtype="varchar";
	property name="sessions"  	 	relationship="one-to-many"  relatedTo="session" relationshipkey="event_detail";

	property name="seats_allocated" type="numeric" dbtype="integer";
	property name="seats_booked"    type="numeric" dbtype="integer";
}
