using afIoc

** The [IoC]`http://www.fantomfactory.org/pods/afIoc` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@NoDoc
const class ConfigModule {
	
	internal static Void defineServices(ServiceDefinitions defs) {
		defs.add(FactoryDefaults#)
		defs.add(ApplicationDefaults#)
		defs.add(ConfigSource#)
	}

	@Contribute { serviceType=DependencyProviders# }
	internal static Void contributeDependencyProviders(Configuration config) {
		config.set("afIocConfig.configProvider", config.autobuild(ConfigProvider#)).before("afIoc.serviceProvider")
	}
}
