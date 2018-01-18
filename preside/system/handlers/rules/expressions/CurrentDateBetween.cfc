/**
 * Expression handler for "Current date is between"
 *
 * @expressionCategory currentdate
 */
component {

	/**
	 * @dateFrom.fieldType date
	 * @dateTo.fieldType   date
	 */
	private boolean function evaluateExpression(
		  required string  dateFrom
		, required string  dateTo
		,          boolean _is = true
	) {
		if ( !IsDate( arguments.dateFrom ) || !IsDate( arguments.dateTo ) ) {
			return false;
		}

		var isMatched = arguments.dateFrom <= Now() && arguments.dateTo >= Now();

		return _is ? isMatched : !isMatched;
	}

}