component {
	property name="presideObjectService" inject="PresideObjectService";

	public string function website( event, rc, prc, args={} ) {
		args.values  = args.values  ?: "";
		args.labels  = args.labels  ?: "";
		args.orderBy = args.orderBy ?: "label";

		if( !isEmpty( args.object ?: "" ) ){
			var records = presideObjectService.selectData(
				  objectName   = args.object
				, selectFields = [ "id", "label" ]
				, orderBy      = args.orderBy
			);

			args.values = ValueList( records.id );
			args.labels = ValueList( records.label );
		}

		return renderView( view="/formcontrols/checkboxList/website", args=args );
	}
}