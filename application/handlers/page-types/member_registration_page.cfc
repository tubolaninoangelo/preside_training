component {
	private function index( event, rc, prc, args={} ) {
		// TODO: create your handler logic here
		return renderView(
			  view          = 'page-types/member_registration_page/index'
			, presideObject = 'member_registration_page'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}
}
