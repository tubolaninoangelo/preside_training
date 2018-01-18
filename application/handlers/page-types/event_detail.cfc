component {

	property name="presideObjectService" inject="PresideObjectService";

	private function index( event, rc, prc, args={} ) {
		var pageId = event.getCurrentPageId();

		return renderView(
			  view          = 'page-types/event_detail/index'
			, presideObject = 'event_detail'
			, id            = pageId
			, args          = args
		);
	}

	private string function _renderRelatedEventsByRegion( event, rc, prc, args={} ) {
		var eventId = event.getCurrentPageId();
		var parentPage = args.parentPage ?: "";

		var relatedRegion  = presideObjectService.selectData(
			  objectName   = "event_detail_region"
			, selectFields = [
				"GROUP_CONCAT(event_detail_region.region) AS region"
			]
			, filter       = { "event_detail_region.event_detail" = eventId }
			, groupBy      = "event_detail_region.event_detail"
		);

		args.relatedEvents = presideObjectService.selectData(
			  objectName = "event_detail"
			, selectFields = [
				  "event_detail.id"
				, "page.title"
				, "page.teaser"
				, "page.main_image"
				, "event_detail.event_startdate"
				, "event_detail.event_enddate"
			]
			, filter = "page.parent_page = '#parentPage#' AND event_detail.event_startdate > NOW() AND event_detail_region.region IN ("& listQualify(relatedRegion.region, "'") &") AND page.id != '#eventId#'"
		);

		return renderView(
			  view = 'page-types/event_detail/_relatedEvent'
			, args = args
		);

	}

	private string function _renderEventDetailProgram( event, rc, prc, args={} ) {

		var pageId = event.getCurrentPageId();

		args.eventProgramme = presideObjectService.selectData(
			  objectName = "programme"
			, selectFields = [
				  "programme.id"
				, "programme.label"
			]
			, filter = { "programme.event_detail" = pageId }
		);

		return renderView(
			  view = 'page-types/event_detail/_eventDetailProgramme'
			, args = args
		);
	}

}
