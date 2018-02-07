component extends="preside.system.services.websiteUsers.WebsiteLoginService" singleton=true {

	public boolean function checkExistingUser( string email_address, string ignore_id = "" ){
		var ignoreIdFilter = ( !isEmpty( ignore_id ) )? "AND id != :id" : "" ;

		return _getUserDao().selectData(
			  selectFields = [ "id" ]
			, filter       = "email_address = :email_address #ignoreIdFilter#"
			, filterParams = {
				  email_address = arguments.email_address
				, id            = arguments.ignore_id
			}
		).recordCount;
	}

	public query function getUserDetailsByEmailAddress( required string email_address ){

		return _getUserDao().selectData(
			  filter       = "email_address = :email_address"
			, filterParams = {
				  email_address = arguments.email_address
			}
		);

	}

}