using afIoc

internal class TestConfig : ConfigTest {
	
	Void testFactoryDef() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		s01	:= (T_MyService01) reg.serviceById("s01")
		verifyEq(s01.c01, "Belgium")
	}

	Void testAppDef() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		s01	:= (T_MyService01) reg.serviceById("s01")
		verifyEq(s01.c02, "Belgium")
	}

	Void testAppOverridesFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		s01	:= (T_MyService01) reg.serviceById("s01")
		verifyEq(s01.c03, "Belgium")
	}

	Void testNullFactoryFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		s01	:= (T_MyService01) reg.serviceById("s01")
		verifyEq(s01.c05, null)
	}

	Void testNullAppFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		s01	:= (T_MyService01) reg.serviceById("s01")
		verifyEq(s01.c06, null)
	}

	Void testNullAppOverrideFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		s01	:= (T_MyService01) reg.serviceById("s01")
		verifyEq(s01.c07, null)
	}

	Void testConfigNotExist() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		verifyErrMsg(ConfigNotFoundErr#, ErrMsgs.configNotFound("c04")) {
			s02	:= (T_MyService02) reg.serviceById("s02")			
		}
	}
	
	Void testCoerceValue() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build.startup
		s01	:= (T_MyService01) reg.serviceById("s01")
		verifyEq(s01.c08, 69)		
	}
}

@SubModule { modules=[IocConfigModule#] }
internal class T_MyModule01 {
	static Void bind(ServiceBinder binder) {
		binder.bind(T_MyService01#).withId("s01")
		binder.bind(T_MyService02#).withId("s02")
	}	

	@Contribute { serviceType=FactoryDefaults# }
	static Void cuntFuct(Configuration config) {
		config["c01"] = "Belgium"	// factory value
		config["c03"] = "UK"		// app override
		
		config["c05"] = null		// null factory value
		config["c07"] = "belgium"	// null factory value
		
		config["c08"] = "69"		// coerce fromStr

		// appDef must override facDefs
		config["c02"] = null
		config["c06"] = null
	}

	@Contribute { serviceType=ApplicationDefaults# }
	static Void cuntApp(Configuration config) {
		config["c02"] = "Belgium"	// app value
		config["c03"] = "Belgium"	// app override
		
		config["c06"] = null		// null app value
		config["c07"] = null		// null app override
	}
}

internal class T_MyService01 {
	@Inject @Config{ id="c01" }	Str? c01
	@Inject @Config{ id="c02" }	Str? c02
	@Inject @Config{ id="c03" }	Str? c03
	
	@Inject @Config{ id="c05" }	Str? c05
	@Inject @Config{ id="c06" }	Str? c06
	@Inject @Config{ id="c07" }	Str? c07

	@Inject @Config{ id="c08" }	Int? c08	// coerce fromStr	
}

internal class T_MyService02 {
	// c04 doesn't exist
	@Inject @Config{ id="c04" }	Str? c04
}
