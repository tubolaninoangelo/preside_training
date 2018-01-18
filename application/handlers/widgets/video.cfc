component {
	private function index( event, rc, prc, args={} ) {

		return renderView( view='widgets/video/index', args=args );
	}

	private function placeholder( event, rc, prc, args={} ) {

		return renderView( view='widgets/video/placeholder', args=args );
	}
}
