using build

class Build : BuildPod {

	new make() {
		podName = "afIocConfig"
		summary = "An IoC library for providing injectable config values"
		version = Version("1.1.0")

		meta = [
			"proj.name"		: "IoC Config",
			"afIoc.module"	: "afIocConfig::ConfigModule",
			"repo.tags"		: "system",
			"repo.public"	: "false"
		]

		index = [	
			"afIoc.module"	: "afIocConfig::ConfigModule"
		]

		depends = [
			"sys 1.0", 
			
			"afBeanUtils  1.0.6  - 1.0",
			"afConcurrent 1.0.10 - 1.0",
			"afIoc        3.0.0  - 3.0"
		]

		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`doc/`]
	}
}
