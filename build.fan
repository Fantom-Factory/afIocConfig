using build

class Build : BuildPod {

	new make() {
		podName = "afIocConfig"
		summary = "An IoC library for providing injectable config values"
		version = Version("1.0.17")

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
			
			"afBeanUtils  1.0.2 - 1.0",
			"afConcurrent 1.0.6 - 1.0",
			"afIoc        2.0.8 - 2.0"
		]

		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`doc/`]
	}
}
