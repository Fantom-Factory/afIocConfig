
** Implement to provide a new source of config properties, or use one of the static methods.
** Instances should be contributed to 'ConfigSource':
** 
** pre>
** @Contribute { serviceType=ConfigSource# }
** Void contributeConfigSource(Configuration config) {
**     config["appConfig"] = ConfigProvider(`myConfig.props`.toFile)
** }
** <pre
** 
** Should you wish to use them for ordering your own providers, the default provider IDs that IocConfig contribute are:
**
**  - 'afIocConfig.factoryDefaults'
**  - 'afIocConfig.envVars'
**  - 'afIocConfig.configFile'
**  - 'afIocConfig.applicationDefaults'
** 
** See 'IocConfigModule' source for details.
**  
@Js
const mixin ConfigProvider {

	** Returns the config properties.
	abstract Str:Obj config()
	
	** Returns a simple 'ConfigProvider' implementation that returns properties from the given config file.
	** May be used like a ctor:
	** 
	**   syntax: fantom
	**   configProvider := ConfigProvider(`myConfig.props`.toFile)
	** 
	** An Err is thrown if 'checked' is 'true' and the file does not exist. 
	static new fromProps(File file, Bool checked := true) {
		if (file.exists.not)
			return !checked ? SimpleConfigProvider([:]) : (null ?: throw IOErr("File not found: ${file.normalize.osPath}"))
		return SimpleConfigProvider(file.readProps)
	}

	** Returns a simple 'ConfigProvider' implementation that returns the given properties.
	** May be used like a ctor:
	** 
	**   syntax: fantom
	**   configProvider := ConfigProvider(["name":"value"])
	static new fromMap(Str:Obj map) {
		SimpleConfigProvider(map)
	}
	
	@NoDoc
	override Str toStr() {
		config.toStr
	}
}

@Js
internal const class SimpleConfigProvider : ConfigProvider {
	override const Str:Obj config
	
	new make(Str:Obj config) {
		this.config = config
	}
}