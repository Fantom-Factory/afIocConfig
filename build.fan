using build

class Build : BuildPod {

	new make() {
		podName = "afIocConfig"
		summary = "An IoC library for providing injectable config values"
		version = Version("1.1.3")

		meta = [
			"pod.dis"		: "IoC Config",
			"afIoc.module"	: "afIocConfig::IocConfigModule",
			"repo.tags"		: "system",
			"repo.public"	: "true"
		]

		index = [	
			"afIoc.module"	: "afIocConfig::ConfigModule"
		]

		depends = [
			"sys          1.0.68 - 1.0", 
			
			"afBeanUtils  1.0.8  - 1.0",
			"afIoc        3.0.0  - 3.0"
		]

		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `test/unit-tests/`]
		resDirs = [`doc/`]
	}
}
