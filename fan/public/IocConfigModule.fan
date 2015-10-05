using afIoc

** The [IoC]`pod:afIoc` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@NoDoc
const class IocConfigModule {
	
	internal static Void defineServices(RegistryBuilder defs) {
		defs.addService(FactoryDefaults#).withRootScope
		defs.addService(ApplicationDefaults#).withRootScope
		defs.addService(ConfigSource#).withRootScope
	}

	@Contribute { serviceType=DependencyProviders# }
	internal static Void contributeDependencyProviders(Configuration config) {
		config["afIocConfig.configProvider"] = config.build(ConfigProvider#)
	}
}
