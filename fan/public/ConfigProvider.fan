
const mixin ConfigProvider {

	abstract Str:Obj config()
	
	static new makeFromProps(File file, Bool checked := true) {
		if (file.exists.not)
			return !checked ? SimpleConfigProvider([:]) : (null ?: throw IOErr("File not found: ${file.normalize.osPath}"))
		return SimpleConfigProvider(file.readProps)
	}

	static new makeFromMap(Str:Obj map) {
		SimpleConfigProvider(map)
	}
}

internal const class SimpleConfigProvider : ConfigProvider {
	override const Str:Obj config
	
	new make(Str:Obj config) {
		this.config = config
	}
}