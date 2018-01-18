/**
 * @singleton
 *
 */
component {

// CONSTRUCTOR

	/**
	 * @dbInfoService.inject  DbInfoService
	 */
	public any function init( required any dbInfoService ) {
		_setDbInfoService( arguments.dbInfoService );
		_setAdapters( {} );

		return this;
	}

// PUBLIC API METHODS
	public any function getAdapter( required string dsn ) {
		var adapters = _getAdapters();

		if ( !adapters.keyExists( arguments.dsn ) ) {
			var dbInfo = _getDbInfo( dsn = arguments.dsn );

			switch( dbInfo.database_productname ) {
				case "MySql":
					adapters[ arguments.dsn ] = new MySqlAdapter();
				break;
				case "Microsoft SQL Server": {

					var majorVersion = listFirst( dbInfo.database_version, "." );
					
					// SQL Server Versions
					// 2008 = 10
					// 2012 = 11

					// a lot easier offset/limit pagination since version 2012, therefore we use a custom adapter
					if ( isNumeric( majorVersion ) && majorVersion >= 11 ) {
						adapters[ arguments.dsn ] = new MsSql2012Adapter();
					}
					else {
						adapters[ arguments.dsn ] = new MsSqlAdapter();
					}

					break;
				}
				case "PostgreSQL":
					adapters[ arguments.dsn ] = new PostgreSqlAdapter();
				break;
				

				default:
					throw( type="PresideObjects.databaseEngineNotSupported", message="The database engine, [#dbInfo.database_productname#], is not supported by the PresideObjects engine at this time" );
			}
		}

		return adapters[ arguments.dsn ];
	}

// PRIVATE HELPERS
	private query function _getDbInfo( required string dsn ) {
		var db = QueryNew('');

		try {
			db = _getDbInfoService().getDatabaseVersion( arguments.dsn );

		} catch ( any e ) {}

		if ( not db.recordCount ) {
			throw( type="PresideObjects.datasourceNotFound", message="Datasource, [#arguments.dsn#], not found." );
		}

		return db;
	}

// GETTERS AND SETTERS
	private any function _getDbInfoService() {
		return _dbInfoService;
	}
	private void function _setDbInfoService( required any dbInfoService ) {
		_dbInfoService = arguments.dbInfoService;
	}

	private any function _getAdapters() {
		return _adapters;
	}
	private void function _setAdapters( required any adapters ) {
		_adapters = arguments.adapters;
	}

}
