/**
 * @showInSiteTree          false
 * @allowedParentPageTypes  events
 * @allowedChildPageTypes   none
 */

component  {
	property name="event_startdate" type="datetime" dbtype="datetime" required=true;
	property name="event_enddate" 	type="datetime" dbtype="datetime" required=true;

	property name="event_document"  relationship="many-to-one"  relatedTo="asset";
	property name="region" 			relationship="many-to-many" relatedTo="region" 	relatedvia="event_detail_region";
	property name="category" 		relationship="many-to-one" 	relatedTo="category";
	property name="programmes"  	relationship="one-to-many" 	relatedto="programme"	relationshipkey="event_detail";

	// Event booking
	property name="event_bookeable" type="boolean" 	dbtype="boolean";
	property name="event_price" 	type="string" 	dbtype="varchar";

	//property name="event_booking"  	relationship="one-to-many" relatedTo="event_booking";
}
