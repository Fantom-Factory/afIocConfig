
@Js
const mixin ConfigProvider {

	abstract Str:Obj config()
	
	static new fromProps(File file, Bool checked := true) {
		if (file.exists.not)
			return !checked ? SimpleConfigProvider([:]) : (null ?: throw IOErr("File not found: ${file.normalize.osPath}"))
		return SimpleConfigProvider(file.readProps)
	}

	static new fromMap(Str:Obj map) {
		SimpleConfigProvider(map)
	}
}

@Js
internal const class SimpleConfigProvider : ConfigProvider {
	override const Str:Obj config
	
	new make(Str:Obj config) {
		this.config = config
	}
}