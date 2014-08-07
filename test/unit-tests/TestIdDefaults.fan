using afIoc::Inject
using afIoc::SubModule
using afIoc::Contribute
using afIoc::Configuration
using afIoc::RegistryBuilder

internal class TestIdDefaults : ConfigTest {

	Void testDefaultIds() {
		reg := RegistryBuilder().addModule(T_MyModule02#).build.startup
		s03	:= (T_MyService03) reg.autobuild(T_MyService03#)
		verifyEq(s03.c01, "You")
		verifyEq(s03.c02, "Got")
		verifyEq(s03.c03, "Any")
		verifyEq(s03.c04, "Grapes?")
	}

	Void testDefaultIdNotFound() {
		reg := RegistryBuilder().addModule(T_MyModule02#).build.startup
		verifyErrMsg(ConfigNotFoundErr#, ErrMsgs.couldNotDetermineId(T_MyService05#c05, "c05 afIocConfig.c05 afIocConfig.t_MyService05.c05 t_MyService05.c05".split)) {
			reg.autobuild(T_MyService05#)
		}
	}

	Void testCaseInsensitive() {
		reg := RegistryBuilder().addModule(T_MyModule02#).build.startup
		s06	:= (T_MyService06) reg.autobuild(T_MyService06#)
		verifyEq(s06.C01, "You")
		verifyEq(s06.C02, "Got")
		
		conSrc	:= (ConfigSource) reg.autobuild(ConfigSource#)
		verifyEq(conSrc.config["AFIOCCONFIG.C02"], "Got")
		verifyEq(conSrc["AFIOCCONFIG.C02"], "Got")
	}
}

@SubModule { modules=[IocConfigModule#] }
internal class T_MyModule02 {
	@Contribute { serviceType=FactoryDefaults# }
	static Void facDefs(Configuration config) {
		config["c01"]							= "You"
		config["afIocConfig.c02"]				= "Got"
		config["afIocConfig.T_MyService03.c03"]	= "Any"
		config["T_MyService03.c04"]				= "Grapes?"
	}
}

internal class T_MyService03 {
	@Inject @Config	Str? c01
	@Inject @Config	Str? c02
	@Inject @Config	Str? c03
	@Inject @Config	Str? c04
}

internal class T_MyService05 {
	@Inject @Config	Str? c05
}

internal class T_MyService06 {
	@Inject @Config	Str? C01
	@Inject @Config	Str? C02
}
