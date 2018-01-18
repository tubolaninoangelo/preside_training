component {

	property name="presideObjectService" inject="PresideObjectService";
	property name="eventService"         inject="EventService";

	private function index( event, rc, prc, args={} ) {
		var pageId              = event.getCurrentPageId();

		args.activeRegionFilter  = rc.region ?: "";
		args.eventCategories     = eventService.getEventCategories( pageId );

		args.eventDetails        = eventService.getAllEventDetail(
			  eventsId           = pageId
			, activeRegionFilter = args.activeRegionFilter
			, activeCategoryFilter = args.eventCategories.category
		);

		args.regionFilter        = eventService.getRegionFilters();

		return renderView(
			  view          = 'page-types/events/index'
			, presideObject = 'events'
			, id            = pageId
			, args          = args
		);
	}

	private string function _renderDetailRegion( event, rc, prc, args={} ) {
		var eventId = args.eventId ?: "";

		args.regionList    = presideObjectService.selectData(
			  objectName   = "event_detail_region"
			, selectFields = [
				  "region.id"
				, "region.label"
			]
			, filter       = { event_detail : eventId }
			, orderBy      = "event_detail_region.sort_order ASC"

		);

		return renderView(
			  view = "page-types/events/_regionList"
			, args = args
		);

	}

	private string function _renderFeaturedEvent( event, rc, prc, args={} ) {
		var eventId = args.eventId;

		args.featuredEvents = eventService.getFeaturedEvents( eventId );

		return renderView(
			  view = "page-types/events/_featuredItem"
			, args = args
		);
	}

}