using build

class Build : BuildPod {

	new make() {
		podName = "afIocConfig"
		summary = "An IoC library for providing injectable config values"
		version = Version("1.0.16")

		meta = [
			"proj.name"		: "IoC Config",
			"afIoc.module"	: "afIocConfig::ConfigModule",
			"repo.tags"		: "system",
			"repo.public"	: "true"
		]

		index = [	
			"afIoc.module"	: "afIocConfig::ConfigModule"
		]

		depends = [
			"sys 1.0", 
			
			"afBeanUtils  1.0.2 - 1.0",
			"afConcurrent 1.0.6 - 1.0",
			"afIoc        2.0.7 - 2.0"
		]

		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`doc/`]
	}
}
