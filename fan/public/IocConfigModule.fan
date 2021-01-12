using afIoc

** The [IoC]`pod:afIoc` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@NoDoc @Js
const class IocConfigModule {

	internal Void defineServices(RegistryBuilder defs) {
		defs.addService(FactoryDefaults#)		.withRootScope
		defs.addService(ApplicationDefaults#)	.withRootScope
		defs.addService(ConfigSource#)			.withRootScope
	}

	@Contribute { serviceType=ConfigSource# }
	internal Void contributeConfigSource(Configuration config) {
		config["afIocConfig.factoryDefaults"] 		= config.scope.serviceById(FactoryDefaults#.qname)
		config["afIocConfig.envVars"]				= ConfigProvider(Env.cur.vars)
		if (Env.cur.runtime != "js") {
			config["afIocConfig.configFile"]		= ConfigProvider(`config.props`.toFile, false)
			config["afIocConfig.secretFile"]		= ConfigProvider(`secret.props`.toFile, false)
		}
		config["afIocConfig.applicationDefaults"]	= config.scope.serviceById(ApplicationDefaults#.qname)
	}

	@Contribute { serviceType=DependencyProviders# }
	internal Void contributeDependencyProviders(Configuration config) {
		config["afIocConfig.configProvider"] = config.build(ConfigDependencyProvider#)
	}
}
