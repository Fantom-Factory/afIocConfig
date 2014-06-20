using afIoc

** The [Ioc]`http://www.fantomfactory.org/pods/afIoc` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@NoDoc
const class IocConfigModule {
	
	internal static Void bind(ServiceBinder binder) {
		binder.bind(FactoryDefaults#)		.withoutProxy	// we gain nuffin by making these proxies
		binder.bind(ApplicationDefaults#)	.withoutProxy	// we gain nuffin by making these proxies
		binder.bind(IocConfigSource#)
		binder.bind(ConfigProvider#)
	}

	@Contribute { serviceType=DependencyProviders# }
	internal static Void contributeDependencyProviderSource(OrderedConfig conf, ConfigProvider configProvider) {
		conf.add(configProvider)
	}

	@Contribute { serviceType=ConfigProvider# }
	internal static Void contributeConfigProviders(OrderedConfig conf) {
		conf.add(Config#)
	}
}
