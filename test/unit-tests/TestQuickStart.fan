using afIoc
//using afIocConfig

internal class Example {

	@Config { id="my.number" }
	@Inject Int? myNumber
	
	Void print() {
		echo("My number is ${myNumber}")
	}
}

internal class AppModule {

	static Void bind(ServiceBinder binder) {
		binder.bindImpl(Example#)
	}

	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(MappedConfig config) {
		// applications override factory defaults
		config["my.number"] = "69"
	}
}

internal class OtherModule {
	
	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(MappedConfig config) {
		// 3rd party libraries set factory defaults
		config["my.number"] = "666"
	}
}

// ---- Standard Support Classes ----

internal class Main {
    Void main() {
        registry := RegistryBuilder().addModules([AppModule#, OtherModule#, IocConfigModule#]).build.startup
        
		example  := (Example) registry.dependencyByType(Example#)
        example.print()  // --> 69
		
		registry.shutdown()
    }
}
