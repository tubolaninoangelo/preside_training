/**
 * @dataManagerGroup Lookup
 * @nolabel           true
 */

component {
	property name="website_user_id"		type="string"	dbtype="varchar"	required="true";
	property name="firstname" 			type="string"	dbtype="varchar"	required="true";
	property name="lastname"			type="string"	dbtype="varchar"	required="true";
	property name="birth_date" 			type="datetime" dbtype="datetime"	required="true";
	property name="gender"				type="string"	dbtype="varchar"	required="true";
	property name="address" 			type="string"	dbtype="text"		required="true";
	property name="interested_in" 		type="string"	dbtype="text"		required="true";
}