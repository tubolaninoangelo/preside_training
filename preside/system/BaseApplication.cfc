/**
 * This exists for legacy applications prior to Preside 10.2.2 whose
 * Application.cfc extends `preside.system.BaseApplication`.
 *
 * Applications using versions of Preside 10.2.2 or above should use
 * the `preside.system.Bootstrap` approach (see documentation).
 *
 */
component extends="Bootstrap" {
	this.name              = ExpandPath( "/" );
	this.sessionManagement = true;
	this.sessionTimeout    = CreateTimeSpan( 0, 0, 40, 0 );
	this.scriptProtect     = "none";

	this.PRESIDE_APPLICATION_RELOAD_LOCK_TIMEOUT = 0;
	this.PRESIDE_APPLICATION_RELOAD_TIMEOUT      = 1200;
	this.COLDBOX_RELOAD_PASSWORD                 = true;

	_setupMappings();
	_setupDefaultTagAttributes();
}