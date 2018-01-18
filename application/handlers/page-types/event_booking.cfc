component {
	private function index( event, rc, prc, args={} ) {
		// TODO: create your handler logic here
		return renderView(
			  view          = 'page-types/event_booking/index'
			, presideObject = 'event_booking'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}
}
