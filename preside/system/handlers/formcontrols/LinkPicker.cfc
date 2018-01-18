component {

	public string function index( event, rc, prc, args={} ) {
		args.control   = "objectPicker";
		args.object    = "link";
		args.quickAdd  = args.quickAdd  ?: true;
		args.quickEdit = args.quickEdit ?: true;

		args.quickAddUrl         = event.buildAdminLink( linkTo="LinkPicker.quickAddForm" );
		args.quickEditUrl        = event.buildAdminLink( linkTo="LinkPicker.quickEditForm", queryString="id=" );
		args.quickAddModalTitle  = "cms:linkpicker.quick.add.modal.title";
		args.quickEditModalTitle = "cms:linkpicker.quick.edit.modal.title";

		return renderViewlet( event="formcontrols.objectPicker.index", args=args );
	}

}