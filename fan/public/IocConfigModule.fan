using afIoc

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
** 
** This class is public so it may be referenced explicitly in test code.
class IocConfigModule {
	
	@NoDoc
	static Void bind(ServiceBinder binder) {
		// TODO: investigate why proxies cause 'Err: No dependency matches type afIoc::ObjLocator'
		binder.bindImpl(FactoryDefaults#).withoutProxy
		binder.bindImpl(ApplicationDefaults#).withoutProxy
		binder.bindImpl(IocConfigSource#)
	}
	
	@NoDoc
	@Contribute 
	static Void contributeDependencyProviderSource(OrderedConfig conf) {
		configProvider := conf.autobuild(ConfigProvider#)
		conf.add(configProvider)
	}

}
