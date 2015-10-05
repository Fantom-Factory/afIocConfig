
** (Service) - Contribute to set factory default '@Config' values. Only 3rd Party libraries, such as 
** [BedSheet]`pod:afBedSheet` need to set / contribute factory defaults. Applications 
** should override factory defaults by contributing to `ApplicationDefaults`. 
** 
** pre>
** syntax: fantom
** 
** const class AppModule {
** 
**     @Contribute { serviceType=FactoryDefaults# }
**     Void contributeFactoryDefaults(Configuration config) {
**         config["config.id"] = "Config Value"
**     }
** <pre
** 
** Config values can be any immutable value.
** 
** @uses Configuration of 'Str:Obj' of IDs to Objs. Obj values must be immutable.
const mixin FactoryDefaults {
	@NoDoc
	abstract Str:Obj? config()
}

internal const class FactoryDefaultsImpl : FactoryDefaults {
	override const Str:Obj? config
	
	new make(Str:Obj? config) {
		this.config = config.toImmutable
	}
}
