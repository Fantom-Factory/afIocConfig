using afIoc

@Js
const mixin ConfigLogger {
	
	@PostInjection
	virtual Void logConfig(Type type := this.typeof) {
		msg := logConfigToStr(this)
		typeof.pod.log.info(msg)
	}
	
	static Str logConfigToStr(Obj configClass) {
		map := Str:Obj?[:] { ordered = true }
		configClass.typeof.fields.findAll { it.hasFacet(Config#) }.each {
			map[it.name.toDisplayName] = it.get(configClass).toStr
		}
		map["."] = ""

		tit := configClass.typeof.name.toDisplayName
		msg := "\n\n"
		msg += "${tit}\n"
		msg += "".padl(tit.size, '=') + "\n"

		keySize := map.keys.reduce(0) |Int size, key->Int| { size.max(key.size) } as Int
		map.each |v, k| {
			if (v != null) {
				if (k.startsWith("."))
					msg += "".padr(keySize + 1, '-') + " : $v\n"
				else
					msg += "$k ".padr(keySize + 1, '.') + " : $v\n"
			}
		}

		return msg
	}
}
