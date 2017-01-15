using afIoc

@Js
internal class TestConfigSource : ConfigTest {
	
	Void testCanOverrideNonExistantConfig() {
		reg := RegistryBuilder().addModule(T_MyModule03#).build
		s04	:= (T_MyService04) reg.rootScope.serviceById("s04")
		
		// we DO NOT want to throw an err if config is ONLY defined in AppDefaults, 'cos most web 
		// apps (mine included!) will define their OWN config - it's not just about overiding! 
		verifyEq(s04.c01, "Belgium")
	}

	Void testBasics_BufFix() {
		reg := RegistryBuilder().addModule(T_MyModule03#).build
		src	:= (ConfigSource) reg.rootScope.serviceByType(ConfigSource#)

		// can't believe I never tested this! get() without a type threw an NPE!
		verifyEq(src.get("c02"), "Belgium")
	}
	
	Void testAnotherDefault() {
		reg := RegistryBuilder()
			.addModule(IocConfigModule#)
			.contributeToServiceType(FactoryDefaults#) |Configuration config| {
				config["skySpark.apiUrl"] = "http://awesome!"
			}.build

		cls := reg.activeScope.build(T_MyService08#) as T_MyService08
		verifyEq(cls.skySparkApiUrl, "http://awesome!")
	}
	
}

@Js
@SubModule { modules=[IocConfigModule#] }
internal const class T_MyModule03 {
	static Void defineServices(RegistryBuilder defs) {
		defs.addService(T_MyService04#).withId("s04")
	}	

	@Contribute { serviceType=ApplicationDefaults# }
	static Void cuntApp(Configuration config) {
		config["c02"] = "Belgium"
	}
}

@Js
internal const class T_MyService04 {
	@Config { id="c02" }	const Str? c01
	new make(|This| in) { in(this) }
}

@Js
internal const class T_MyService08 {
	@Config const Str skySparkApiUrl
	new make(|This| in) { in(this) }
}