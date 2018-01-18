/**
 * The system configuration service provides the API layer
 * for interacting with PresideCMS' [[editablesystemsettings]].
 *
 * @singleton
 * @autodoc
 */
component displayName="System configuration service" {

// CONSTRUCTOR
	/**
	 * @autoDiscoverDirectories.inject presidecms:directories
	 * @dao.inject                     presidecms:object:system_config
	 * @injectedConfig.inject          coldbox:setting:injectedConfig
	 * @formsService.inject            delayedInjector:formsService
	 * @siteService.inject             delayedInjector:siteService
	 */
	public any function init(
		  required array  autoDiscoverDirectories
		, required any    dao
		, required struct injectedConfig
		, required any    formsService
		, required any    siteService
	) {
		_setAutoDiscoverDirectories( arguments.autoDiscoverDirectories );
		_setDao( arguments.dao );
		_setInjectedConfig( arguments.injectedConfig );
		_setFormsService( arguments.formsService );
		_setSiteService( arguments.siteService );
		_setLoaded( false );

		return this;
	}

// PUBLIC API METHODS
	/**
	 * Returns a setting that has been saved.
	 * See [[editablesystemsettings]] for a full guide.
	 *
	 * @autodoc
	 * @category.hint  Category name of the setting to get
	 * @setting.hint   Name of the setting to get
	 * @default.hint   A default value to return should no value be saved for the setting
	 *
	 */
	public string function getSetting( required string category, required string setting, string default="" ) {
		_reloadCheck();

		var injected   = _getInjectedConfig();
		var activeSite = _getSiteService().getActiveSiteId();
		var result     = _getDao().selectData(
			  selectFields = [ "value" ]
			, filter       = { category = arguments.category, setting = arguments.setting, site=activeSite }
		);

		if ( result.recordCount ) {
			return result.value;
		}

		result = _getDao().selectData(
			  selectFields = [ "value" ]
			, filter       = "category = :category and setting = :setting and site is null"
			, filterParams = { category = arguments.category, setting = arguments.setting }
		);

		if ( result.recordCount ) {
			return result.value;
		}

		return injected[ "#arguments.category#.#arguments.setting#" ] ?: arguments.default;
	}

	/**
	 * Returns all the saved settings for a given category.
	 * See [[editablesystemsettings]] for a full guide.
	 *
	 * @autodoc
	 * @category.hint           The name of the category whose settings you wish to get
	 * @includeDefaults.hint    Whether to include default global and injected settings or whether to just return the settings for the current site
	 * @globalDefaultsOnly.hint Whether to only include default global and injected settings or whether to include all amalgamated settings
	 *
	 */
	public struct function getCategorySettings(
		  required string  category
		,          boolean includeDefaults    = true
		,          boolean globalDefaultsOnly = false
		,          string  siteId             = _getSiteService().getActiveSiteId()
	) {
		_reloadCheck();

		var result = {};

		if ( !arguments.globalDefaultsOnly ) {
			var rawSiteResult = _getDao().selectData(
				  selectFields = [ "setting", "value" ]
				, filter       = { category = arguments.category, site=arguments.siteId }
			);

			for( var record in rawSiteResult ){
				result[ record.setting ] = record.value;
			}
		}

		if ( arguments.includeDefaults ) {
			var injectedStartsWith = "#arguments.category#.";
			var rawGlobalResult    = _getDao().selectData(
				  selectFields = [ "setting", "value" ]
				, filter       = "category = :category and site is null"
				, filterParams = { category = arguments.category }
			);

			for( var record in rawGlobalResult ){
				if ( !result.keyExists( record.setting ) ) {
					result[ record.setting ] = record.value;
				}
			}

			var injected = _getInjectedConfig().filter( function( key ){ return key.startsWith( injectedStartsWith ) } );
			for( var key in injected ) {
				var setting = ListRest( key, "." );

				if ( !result.keyExists( setting ) ) {
					result[ setting ] = injected[ key ];
				}
			}
		}

		return result;
	}

	/**
	 * Saves the value of a setting.
	 * See [[editablesystemsettings]] for a full guide.
	 *
	 * @autodoc
	 * @category.hint  Category name of the setting to save
	 * @setting.hint   Name of the setting to save
	 * @value.hint     Value to save
	 * @siteId.hint    ID of site to which the setting applies (optional, if empty setting is treated as system wide default)
	 *
	 */
	public any function saveSetting(
		  required string category
		, required string setting
		, required string value
		,          string siteId = ""
	)  {
		_reloadCheck();

		var dao = _getDao();

		transaction {
			var filter = "category = :category and setting = :setting and site ";
			var params = { category = arguments.category, setting = arguments.setting };

			if ( Len( Trim( arguments.siteId ) ) ) {
				filter &= "= :site";
				params.site = arguments.siteId;
			} else {
				filter &= "is null";
			}

			var currentRecord = dao.selectData(
				  selectFields = [ "id" ]
				, filter       = filter
				, filterParams = params
			);

			if ( currentRecord.recordCount ) {
				return dao.updateData(
					  data = { value = arguments.value }
					, id   = currentRecord.id
				);
			} else {
				return dao.insertData(
					data = {
						  category = arguments.category
						, setting  = arguments.setting
						, value    = arguments.value
						, site     = arguments.siteId
					}
				);
			}
		}
	}

	public any function deleteSetting(
		  required string category
		, required string setting
		,          string siteId = ""
	)  {
		_reloadCheck();

		var dao    = _getDao();
		var filter = "category = :category and setting = :setting and site ";
		var params = { category = arguments.category, setting = arguments.setting };

		if ( Len( Trim( arguments.siteId ) ) ) {
			filter &= "= :site";
			params.site = arguments.siteId;
		}

		return dao.deleteData(
			  filter       = filter
			, filterParams = params
		);
	}

	public array function listConfigCategories() {
		_reloadCheck();

		var categories = _getConfigCategories();
		var result    = [];

		for( var id in categories ){
			ArrayAppend( result, categories[ id ] );
		}

		return result;
	}

	public ConfigCategory function getConfigCategory( required string id ) {
		_reloadCheck();

		var categories = _getConfigCategories();

		if ( categories.keyExists( arguments.id ) ) {
			return categories[ arguments.id ];
		}

		categories = categories.keyArray();
		categories.sort( "textnocase" );
		categories = SerializeJson( categories );

		throw(
			  type    = "SystemConfigurationService.category.notFound"
			, message = "The configuration category [#arguments.id#] could not be found. Configured categories are: #categories#"
		);
	}

	public void function reload() {
		_setConfigCategories({});
		_autoDiscoverCategories();
	}

// PRIVATE HELPERS
	private void function _autoDiscoverCategories() {
		var objectsPath             = "/forms/system-config";
		var ids                     = {};
		var autoDiscoverDirectories = _getAutoDiscoverDirectories();

		for( var dir in autoDiscoverDirectories ) {
			dir   = ReReplace( dir, "/$", "" );
			var objects = DirectoryList( dir & objectsPath, false, "query", "*.xml" );

			for ( var obj in objects ) {
				if ( obj.type eq "File" ) {
					ids[ ReReplace( obj.name, "\.xml$", "" ) ] = true;
				}
			}
		}

		for( var id in ids ) {
			if ( _getFormsService().formExists( formName="system-config." & id, checkSiteTemplates=false ) ) {
				_registerCategory( id = LCase( id ) );
			}
		}
	}

	private void function _registerCategory( required string id ) {
		var categories = _getConfigCategories();

		categories[ arguments.id ] = new ConfigCategory(
			  id               = arguments.id
			, name             = _getConventionsBaseCategoryName( arguments.id )
			, description      = _getConventionsBaseCategoryDescription( arguments.id )
			, icon             = _getConventionsBaseCategoryIcon( arguments.id )
			, form             = _getConventionsBaseCategoryForm( arguments.id )
			, siteForm         = _getConventionsBaseSiteCategoryForm( arguments.id )
		);
	}

	private string function _getConventionsBaseCategoryName( required string id ) {
		return "system-config.#arguments.id#:name";
	}
	private string function _getConventionsBaseCategoryDescription( required string id ) {
		return "system-config.#arguments.id#:description";
	}
	private string function _getConventionsBaseCategoryIcon( required string id ) {
		return "system-config.#arguments.id#:iconClass";
	}
	private string function _getConventionsBaseCategoryForm( required string id ) {
		return "system-config.#arguments.id#";
	}
	private string function _getConventionsBaseSiteCategoryForm( required string id ) {
		var fullFormName = _getConventionsBaseCategoryForm( arguments.id );

		return _getFormsService().createForm( basedOn=fullFormName, generator=function( definition ){
			var rawForm = definition.getRawDefinition();
			var tabs    = rawForm.tabs ?: [];

			for( var tab in tabs ) {
				var fieldsets = tab.fieldsets ?: [];

				for ( var fieldset in tab.fieldsets ) {
					var fields = fieldset.fields ?: [];

					for( var field in fields ) {
						definition.modifyField( name=field.name ?: "", fieldset=fieldset.id ?: "", tab=tab.id ?: "", required=false );
					}
				}
			}
		} );
	}

	private void function _reloadCheck() {
		if ( !_isLoaded() ) {
			reload();
			_setLoaded( true );
		}
	}

// GETTERS AND SETTERS
	private array function _getAutoDiscoverDirectories() {
		return _autoDiscoverDirectories;
	}
	private void function _setAutoDiscoverDirectories( required array autoDiscoverDirectories ) {
		_autoDiscoverDirectories = arguments.autoDiscoverDirectories;
	}

	private any function _getDao() {
		return _dao;
	}
	private void function _setDao( required any dao ) {
		_dao = arguments.dao;
	}

	private struct function _getConfigCategories() {
		return _configCategories;
	}
	private void function _setConfigCategories( required struct configCategories ) {
		_configCategories = arguments.configCategories;
	}

	private struct function _getInjectedConfig() {
		return _injectedConfig;
	}
	private void function _setInjectedConfig( required struct injectedConfig ) {
		_injectedConfig = arguments.injectedConfig;
	}

	private struct function _getFormsService() {
		return _formsService;
	}
	private void function _setFormsService( required struct formsService ) {
		_formsService = arguments.formsService;
	}

	private boolean function _isLoaded() {
		return _loaded;
	}
	private void function _setLoaded( required boolean loaded ) {
		_loaded = arguments.loaded;
	}

	private any function _getSiteService() {
		return _siteService;
	}
	private void function _setSiteService( required any siteService ) {
		_siteService = arguments.siteService;
	}
}