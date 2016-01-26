using afIoc

@Js
internal class TestEnv : ConfigTest {
	
	Void testConfig() {
		reg := RegistryBuilder()
			.addModule(IocConfigModule#)
			.contributeToService(ConfigSource#.qname) |Configuration config| {
				config["myEnv"] = ConfigProvider([
					"afIocConfig.env"	: "dev",
					"afIocConfig.envs"	: "dev, test, prod",
					"acme.prop"			: "dredd",
					"dev.acme.prop"		: "anderson",
					"test.acme.prop"	: "hershey",
					"prod.acme.prop"	: "death"
				])
			}
			.build
		
		config := (ConfigSource) reg.activeScope.serviceById(ConfigSource#.qname)
		verifyEq(config.configMuted, Str:Obj?["acme.prop":"anderson"])

		// config, despite not being muted, should not contain env props
		// we want a working set of props, not a work-in-progress set of props!
		verifyEq   (config.config["acme.prop"], "anderson")
		verifyFalse(config.config.containsKey("dev.acme.prop"))
		verifyFalse(config.config.containsKey("test.acme.prop"))
		verifyFalse(config.config.containsKey("test.acme.prop"))

		// test config logging
		configClass := reg.activeScope.build(T_MyConfigClass#) as T_MyConfigClass
		verifyEq(configClass.acmeProp, "anderson")
	}
}

@Js
internal const class T_MyConfigClass : ConfigClass {
	@Config const Str?	acmeProp
	new make(|This|in) { in(this) }
}