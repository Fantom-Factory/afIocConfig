using afIoc

@Js
internal class TestIdDefaults : ConfigTest {

	Void testDefaultIds() {
		reg := RegistryBuilder().addModule(T_MyModule02#).build
		s03	:= (T_MyService03) reg.rootScope.build(T_MyService03#)
		verifyEq(s03.c01, "You")
		verifyEq(s03.c02, "Got")
		verifyEq(s03.c03, "Any")
		verifyEq(s03.c04, "Grapes?")
		verifyEq(s03.c05GotDots, "...")
	}

	Void testDefaultIdNotFound() {
		reg := RegistryBuilder().addModule(T_MyModule02#).build
		verifyErrMsg(IocErr#, "Could not determine config ID for field 'afIocConfig::T_MyService05.c05' - tried 'c05', 'afIocConfig.c05', 'afIocConfig.t_MyService05.c05', 't_MyService05.c05'") {
			reg.rootScope.build(T_MyService05#)
		}
	}

	Void testCaseInsensitive() {
		reg := RegistryBuilder().addModule(T_MyModule02#).build
		s06	:= (T_MyService06) reg.rootScope.build(T_MyService06#)
		verifyEq(s06.C01, "You")
		verifyEq(s06.C02, "Got")
		
		conSrc	:= (ConfigSource) reg.rootScope.serviceByType(ConfigSource#)
		verifyEq(conSrc.config["AFIOCCONFIG.C02"], "Got")
		verifyEq(conSrc["AFIOCCONFIG.C02"], "Got")
	}
}

@Js
@SubModule { modules=[IocConfigModule#] }
internal const class T_MyModule02 {
	@Contribute { serviceType=FactoryDefaults# }
	static Void facDefs(Configuration config) {
		config["c01"]							= "You"
		config["afIocConfig.c02"]				= "Got"
		config["afIocConfig.T_MyService03.c03"]	= "Any"
		config["T_MyService03.c04"]				= "Grapes?"
		config["c05.got.dots"] 					= "..."
	}
}

@Js
internal class T_MyService03 {
	@Config	Str? c01
	@Config	Str? c02
	@Config	Str? c03
	@Config	Str? c04
	@Config	Str? c05GotDots
}

@Js
internal class T_MyService05 {
	@Config	{ optional=false } Str? c05
}

@Js
internal class T_MyService06 {
	@Config	Str? C01
	@Config	Str? C02
}
