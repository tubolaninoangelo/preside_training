component {
	// private string function datatable( event, rc, prc, args={} ) {
	// 	var subTopic = args.subtopic              ?: "";
	// 	var data     = deserializeJSON(args.data) ?: {};

	// 	return renderView( view = "/renderers/notifications/#subTopic#/datatable", args=data );
	// }

	private string function full( event, rc, prc, args={} ) {
		var subTopic = args.subtopic ?: "";
		var data     = args.data     ?: {};

		return renderView( view = "/renderers/notifications/#subTopic#/full", args=data );
	}

	private string function emailSubject( event, rc, prc, args={} ) {
        return "A customer complaint was filed through the website";
    }

	private string function emailHtml( event, rc, prc, args={} ) {
		var subTopic = args.subtopic              ?: "";
	 	var data     = deserializeJSON(args.data) ?: {};

        return renderView( view = "/renderers/notifications/#subTopic#/emailHtml", args = data );
    }

    private string function emailText( event, rc, prc, args={} ) {
    	var subTopic = args.subtopic              ?: "";
    	var data     = deserializeJSON(args.data) ?: {};

        return renderView( view = "/renderers/notifications/#subTopic#/emailText" , args = data );
    }
}