using afIoc

internal class TestConfigSource : ConfigTest {
	
	Void testCanOverrideNonExistantConfig() {
		reg := RegistryBuilder().addModule(T_MyModule03#).build.startup
		s04	:= (T_MyService04) reg.serviceById("s04")
		
		// we DO NOT want to throw an err if config is ONLY defined in AppDefaults, 'cos most web 
		// apps (mine included!) will define their OWN config - it's not just about overiding! 
		verifyEq(s04.c01, "Belgium")
	}

	Void testBasics_BufFix() {
		reg := RegistryBuilder().addModule(T_MyModule03#).build.startup
		src	:= (ConfigSource) reg.dependencyByType(ConfigSource#)

		// can't believe I never tested this! get() without a type threw an NPE!
		verifyEq(src.get("c02"), "Belgium")
	}
	
}

@SubModule { modules=[ConfigModule#] }
internal class T_MyModule03 {
	static Void defineServices(ServiceDefinitions defs) {
		defs.add(T_MyService04#).withId("s04")
	}	

	@Contribute { serviceType=ApplicationDefaults# }
	static Void cuntApp(Configuration config) {
		config["c02"] = "Belgium"
	}
}

internal class T_MyService04 {
	@Config{ id="c02" }	Str? c01
}