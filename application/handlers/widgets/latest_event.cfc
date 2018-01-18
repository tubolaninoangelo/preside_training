component {

	property name="presideObjectService" inject="PresideObjectService";

	private function index( event, rc, prc, args={} ) {
		var items   = args.event_items ?: "";
		var maxItems = val( args.max_items ?: 3 );

		args.latestEvents   = queryNew( '' );

		var selectFields = [
			  "event_detail.id"
			, "page.title"
			, "page.main_image"
			, "page.teaser"
			, "event_detail.event_startdate"
            , "event_detail.event_enddate"
		];

		if( !isEmpty( items ) ) {
			args.latestEvents = presideObjectService.selectData(
				  objectName   = "event_detail"
				, filter       = { id = listToArray( items ) }
				, maxRows      = maxItems
				, orderBy      = "FIELD(event_detail.id,#listQualify(items,"'")#)"
				, selectFields = selectFields
				, groupBy      = "event_detail.id"
			);
		}

		if( isEmpty( items ) ) {
			args.latestEvents = presideObjectService.selectData(
				  objectName   = "event_detail"
				, maxRows      = maxItems
				, orderBy      = "event_detail.event_startdate DESC"
				, filter       = "event_detail.event_startdate > NOW()"
				, selectFields = selectFields
				, groupBy      = "event_detail.id"
			);
		}

		return renderView( view='widgets/latest_event/index', args=args );
	}

	private function placeholder( event, rc, prc, args={} ) {

		return renderView( view='widgets/latest_event/placeholder', args=args );
	}
}
