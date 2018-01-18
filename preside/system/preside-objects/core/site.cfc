/**
 * The Site object represents a site / microsite that is managed by the CMS.
 *
 * Each site will have its own tree of [[presideobject-page]] records.
 */
component output=false extends="preside.system.base.SystemPresideObject" labelfield="name" displayName="Site"  {
	property name="name"     type="string" dbtype="varchar" maxlength="200" required=true  uniqueindexes="sitename";
	property name="domain"   type="string" dbtype="varchar" maxlength="255" required=true  uniqueindexes="sitepath|1" format="regex:^[a-zA-Z0-9][a-zA-Z0-9-_\.]+$";
	property name="path"     type="string" dbtype="varchar" maxlength="255" required=true  uniqueindexes="sitepath|2" format="regex:^\/[a-zA-Z0-9\/-_]*$";
	property name="protocol" type="string" dbtype="varchar" maxlength="5"   required=false enum="siteProtocol";
	property name="template" type="string" dbtype="varchar" maxlength="50"  required=false;

	property name="hide_from_search"     type="boolean" dbtype="boolean"                  required=false default=false;
	property name="author"               type="string"  dbtype="varchar" maxLength="100"  required=false;
	property name="browser_title_prefix" type="string"  dbtype="varchar" maxLength="100"  required=false;
	property name="browser_title_suffix" type="string"  dbtype="varchar" maxLength="100"  required=false;
}