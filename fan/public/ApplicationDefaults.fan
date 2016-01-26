
** (Service) - Contribute to set application default '@Config' values, overriding any factory defaults. 
**
** pre>
** syntax: fantom
** 
** const class AppModule {
** 
**   @Contribute { serviceType=ApplicationDefaults# }
**   Void contributeApplicationDefaults(Configuration config) {
**       config["config.id"] = "Config Value"
**   }
** <pre
** 
** Config values can be any immutable value.
** 
** @uses Configuration of 'Str:Obj' of IDs to Objs. Obj values must be immutable.
@Js
const mixin ApplicationDefaults : ConfigProvider { 

	@NoDoc
	override abstract Str:Obj? config()
}

@Js
internal const class ApplicationDefaultsImpl : ApplicationDefaults {
	override const Str:Obj? config
	
	new make(Str:Obj? config) {
		this.config = config.toImmutable
	}
}
