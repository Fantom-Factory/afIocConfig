using afIoc
using afIocConfig

class Example {
	@Config { id="my.config" } Str? myConfig	
}

const class OtherModule {
	@Contribute { serviceType=FactoryDefaults# }
	Void contributeFactoryDefaults(Configuration config) {
		config["my.config"] = "3rd party libraries set Factory defaults"
	}
}

const class AppModule {
	@Contribute { serviceType=ApplicationDefaults# }
	Void contributeApplicationDefaults(Configuration config) {
		config["my.config"] = "Applications override Factory defaults"
	}
}

class Main {
    Void main() {
        registry := RegistryBuilder().addModules([IocConfigModule#, AppModule#, OtherModule#]).build()
        
		example  := (Example) registry.rootScope.build(Example#)
        echo("--> ${example.myConfig}")  // --> Applications override Factory defaults
		
		registry.shutdown()
    }
}
