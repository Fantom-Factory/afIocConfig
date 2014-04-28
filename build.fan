using build

class Build : BuildPod {

	new make() {
		podName = "afIocConfig"
		summary = "An IoC library for providing injectable config values"
		version = Version("1.0.7")

		meta = [
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "IoC Config",
			"proj.uri"		: "http://www.fantomfactory.org/pods/afIocConfig",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afiocconfig",
			"license.name"	: "The MIT Licence",
			"repo.private"	: "true"

			,"afIoc.module"	: "afIocConfig::IocConfigModule"
		]

		index = [	
			"afIoc.module"	: "afIocConfig::IocConfigModule"
		]

		depends = ["sys 1.0", "afIoc 1.5.6+"]
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
		resDirs = resDirs.exclude { it.toStr.startsWith("res/test/") }
		
		super.compile
		
		// copy src to %FAN_HOME% for F4 debugging
		log.indent
		destDir := Env.cur.homeDir.plus(`src/${podName}/`)
		destDir.delete
		destDir.create		
		`fan/`.toFile.copyInto(destDir)		
		log.info("Copied `fan/` to ${destDir.normalize}")
		log.unindent
	}
}
