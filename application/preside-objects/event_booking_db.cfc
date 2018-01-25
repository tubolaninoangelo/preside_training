/**
 * @dataManagerGroup Events
 */
component {

	property name="event_price" 	type="string" dbtype="varchar";
	property name="firstname" 		type="string" dbtype="varchar" maxLength=50;
	property name="lastname" 		type="string" dbtype="varchar" maxLength=50;
	property name="email" 			type="string" dbtype="varchar";
	property name="number_of_seat" 	type="numeric" dbtype="varchar";
	property name="total_amount" 	type="numeric" dbtype="float";
	property name="special_request" type="string" dbtype="varchar";

}