using build

class Build : BuildPod {

	new make() {
		podName = "afIocConfig"
		summary = "An IoC library for providing injectable config values"
		version = Version("1.0.14")

		meta = [
			"proj.name"		: "IoC Config",
			"afIoc.module"	: "afIocConfig::IocConfigModule",
			"tags"			: "system",
			"repo.private"	: "false"
		]

		index = [	
			"afIoc.module"	: "afIocConfig::IocConfigModule"
		]

		depends = [
			"sys 1.0", 
			
			"afBeanUtils 1.0.2+",
			"afConcurrent 1.0.6+",
			"afIoc 1.7.6+"
		]

		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [,]
	}
}
