using afIoc3

internal class TestConfig : ConfigTest {
	
	Void testFactoryDef() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s01	:= (T_MyService01) reg.rootScope.serviceById("s01")
		verifyEq(s01.c01, "Belgium")
	}

	Void testAppDef() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s01	:= (T_MyService01) reg.rootScope.serviceById("s01")
		verifyEq(s01.c02, "Belgium")
	}

	Void testAppOverridesFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s01	:= (T_MyService01) reg.rootScope.serviceById("s01")
		verifyEq(s01.c03, "Belgium")
	}

	Void testNullFactoryFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s01	:= (T_MyService01) reg.rootScope.serviceById("s01")
		verifyEq(s01.c05, null)
	}

	Void testNullAppFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s01	:= (T_MyService01) reg.rootScope.serviceById("s01")
		verifyEq(s01.c06, null)
	}

	Void testNullAppOverrideFactory() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s01	:= (T_MyService01) reg.rootScope.serviceById("s01")
		verifyEq(s01.c07, null)
	}

	Void testConfigNotExist() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		verifyErrMsg(IocErr#, ErrMsgs.configNotFound("c04")) {
			s02	:= (T_MyService02) reg.rootScope.serviceById("s02")			
		}
	}

	Void testOptionalConfigNotExist() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s07	:= (T_MyService07) reg.rootScope.serviceById("s07")			
		verifyNull(s07.c04)
		verifyNull(s07.cNoId)
	}
	
	Void testCoerceValue() {
		reg := RegistryBuilder().addModule(T_MyModule01#).build
		s01	:= (T_MyService01) reg.rootScope.serviceById("s01")
		verifyEq(s01.c08, 69)		
	}
}

@SubModule { modules=[ConfigModule#] }
internal const class T_MyModule01 {
	static Void defineServices(RegistryBuilder defs) {
		defs.addService(T_MyService01#).withId("s01")
		defs.addService(T_MyService02#).withId("s02")
		defs.addService(T_MyService07#).withId("s07")
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

internal const class T_MyService01 {
	new make(|This|in) { in(this) }
	
	@Config { id="c01" } const Str? c01
	@Config { id="c02" } const Str? c02
	@Config { id="c03" } const Str? c03
	
	// throw some dodgy @Injects into the mix
	@Inject
	@Config { id="c05" } const Str? c05
	@Inject
	@Config { id="c06" } const Str? c06
	@Inject
	@Config { id="c07" } const Str? c07

	@Config { id="c08" } const Int? c08	// coerce fromStr
}

internal const class T_MyService02 {
	new make(|This|in) { in(this) }
	// c04 doesn't exist
	@Config { id="c04" } const Str? c04
}

internal const class T_MyService07 {
	new make(|This|in) { in(this) }
	// c04 doesn't exist
	@Config { optional=true; id="c04" }	const Str? c04
	@Config { optional=true }			const Str? cNoId
}
