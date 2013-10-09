using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afIocConfig"
		summary = "(Internal) A library for providing injectable config values."
		version = Version([0,0,3])

		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/Alien-Factory/afiocconfig",
					"proj.name"		: "IocConfig",
					"license.name"	: "BSD 2-Clause License",
					"repo.private"	: "true"

					,"afIoc.module"	: "afIocConfig::IocConfigModule"
				]


		index	= [	"afIoc.module"	: "afIocConfig::IocConfigModule"
				]


		depends = ["sys 1.0", "afIoc 1.4+"]
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true

		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
		resDirs = resDirs.exclude { it.toStr.startsWith("test/") }
	}
}
