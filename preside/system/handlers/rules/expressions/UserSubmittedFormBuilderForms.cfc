/**
 * Expression handler for "User has visited any/all of the following pages"
 *
 * @feature websiteUsers
 * @expressionContexts user
 * @expressionCategory website_user
 */
component {

	property name="websiteUserActionService" inject="websiteUserActionService";

	/**
	 * @forms.fieldType    object
	 * @forms.object       formbuilder_form
	 */
	private boolean function evaluateExpression(
		  required string  forms
		,          boolean _has = true
		,          boolean _all = false
		,          struct  _pastTime
	) {
		var userId = payload.user.id ?: "";

		if ( forms.listLen() > 1 && _all ) {
			for( var fbform in forms.listToArray() ) {
				var result = websiteUserActionService.hasPerformedAction(
					  type        = "formbuilder"
					, action      = "submitform"
					, userId      = userId
					, identifiers = [ fbform ]
					, dateFrom    = _pastTime.from ?: ""
					, dateTo      = _pastTime.to   ?: ""
				);

				if ( result != _has ) {
					return false;
				}
			}

			return true;
		} else {
			var result = websiteUserActionService.hasPerformedAction(
				  type        = "formbuilder"
				, action      = "submitform"
				, userId      = userId
				, identifiers = ListToArray( forms )
				, dateFrom    = _pastTime.from ?: ""
				, dateTo      = _pastTime.to   ?: ""
			);
		}

		return _has ? result : !result;
	}

	/**
	 * @objects website_user
	 *
	 */
	private array function prepareFilters(
		  required string  forms
		,          boolean _has               = true
		,          boolean _all               = false
		,          struct  _pastTime          = {}
		,          string  filterPrefix       = ""
		,          string  parentPropertyName = ""
	) {
		return websiteUserActionService.getUserPerformedActionFilter(
			  action             = "submitform"
			, type               = "formbuilder"
			, has                = arguments._has
			, datefrom           = arguments._pastTime.from ?: ""
			, dateto             = arguments._pastTime.to   ?: ""
			, identifiers        = arguments.forms.listToArray()
			, allIdentifiers     = arguments._all
			, filterPrefix       = arguments.filterPrefix
			, parentPropertyName = arguments.parentPropertyName
		);
	}

}