using afIoc
//using afIocConfig

internal class Example {
	@Config { id="my.config" }
	@Inject Str? myConfig	
}


internal class OtherModule {
	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(Configuration config) {
		config["my.config"] = "3rd party libraries set Factory defaults"
	}
}

internal class AppModule {
	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(Configuration config) {
		config["my.config"] = "Applications override Factory defaults"
	}
}

internal class Main {
    Void main() {
        registry := RegistryBuilder().addModules([AppModule#, OtherModule#, IocConfigModule#]).build.startup
        
		example  := (Example) registry.autobuild(Example#)
        echo(example.myConfig)  // --> Applications override Factory defaults
		
		registry.shutdown()
    }
}
