using afIoc::ServiceBinder
using afIoc::Contribute
using afIoc::DependencyProviderSource
using afIoc::OrderedConfig

** The [Ioc]`http://www.fantomfactory.org/pods/afIoc` module class.
** 
** This class is public so it may be referenced explicitly in test code.
const class IocConfigModule {
	
	internal static Void bind(ServiceBinder binder) {
		binder.bindImpl(FactoryDefaults#).withoutProxy		// we gain nuffin by making these proxies
		binder.bindImpl(ApplicationDefaults#).withoutProxy	// we gain nuffin by making these proxies
		binder.bindImpl(IocConfigSource#).withoutProxy		// has default values
	}

	@Contribute { serviceType=DependencyProviderSource# }
	internal static Void contributeDependencyProviderSource(OrderedConfig conf) {
		configProvider := conf.autobuild(ConfigProvider#)
		conf.add(configProvider)
	}
}
