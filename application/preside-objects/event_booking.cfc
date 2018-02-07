/**
 * @dataManagerGroup Events
 * @nolabel          true
 * @datamanagerGridFields event_title,email,event_price
 */
component {
	property name="event_id"        type="string"   dbtype="varchar"    required="true";
	property name="website_user"    type="string"   dbtype="varchar"    required="true";
	property name="event_title" 	type="string" 	dbtype="varchar";
	property name="event_price" 	type="numeric" 	dbtype="int";
	property name="firstname" 		type="string" 	dbtype="varchar"	maxLength=50;
	property name="lastname" 		type="string" 	dbtype="varchar" 	maxLength=50;
	property name="email" 			type="string" 	dbtype="varchar";
	property name="number_of_seat" 	type="numeric" 	dbtype="int";
	property name="total_amount" 	type="numeric" 	dbtype="float";
	property name="session" 		type="string"  	dbtype="varchar";
	property name="special_request" type="string" 	dbtype="varchar";

}