/**
 * @allowedParentPageTypes   *
 * @allowedChildPageTypes    event_detail
 */

component  {
	property name="items_per_page" type="numeric" dbtype="int";

	property name="featured_event" 	relationship="many-to-many" 	relatedto="event_detail" relatedvia="event_detail_featured" required=false;
	property name="region" 			relationship="many-to-one" 		relatedTo="region";
	property name="categories" 		relationship="many-to-many" 	relatedTo="category" 	relatedvia="events_categories";
}