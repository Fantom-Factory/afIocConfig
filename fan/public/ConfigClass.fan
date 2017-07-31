using afIoc

** A utility mixin that simply logs injected config on startup.
** Because sometimes it's nice to see what your app is using! 
** Example:
** 
** pre>
** syntax: fantom
** using afIocConfig
** 
** const class AppConfig : ConfigClass {
**     @Config const Uri jdbcUrl
**     @Config const Str username
**     @Config const Str password
**     @Config const Str messageOfTheDay
** 
**     new make(|This| f) { f(this) } 
** }
** <pre 
** 
** Will print:
** 
** pre>
** App Config
** ==========
** Jdbc Url ......... : jdbc:wotever
** Username ......... : knobs
** Password ......... : secret
** Message Of The Day : Eat moar ice-cream!
** <pre
@Js
mixin ConfigClass {
	
	** Logs the '@Config' fields to 'info'.
	@PostInjection
	virtual Void logConfig() {
		msg := dump(this)
		typeof.pod.log.info(msg)
	}
	
	** Dumps '@Config' fields of the given 'configClass' to a 'Str', appending any extra properties to the end.
	** 
	** Any key starting with '---' is used as a separator.
	** 
	** Is 'static' so it may be called from anywhere.
	static Str dump(Obj configClass, Str? title := null, [Str:Obj]? extra := null) {
		dumpFields(configClass, configClass.typeof.fields.findAll { it.hasFacet(Config#) }, title, extra)
	}

	** Dumps fields of the given 'configClass' to a 'Str', appending any extra properties to the end.
	** 
	** Any key starting with '---' is used as a separator.
	** 
	** Is 'static' so it may be called from anywhere.
	static Str dumpFields(Obj configClass, Field[] fields, Str? title := null, [Str:Obj]? extra := null) {
		map := Str:Obj?[:] { ordered = true }
		fields.each {
			map[it.name.toDisplayName] = it.get(configClass)?.toStr
		}
		if (extra != null)
			map.setAll(extra)

		tit := title ?: configClass.typeof.name.toDisplayName
		msg := "\n\n"
		msg += "${tit}\n"
		msg += "".padl(tit.size, '=') + "\n"

		keySize := map.keys.reduce(0) |Int size, key->Int| { size.max(key.size) } as Int
		map.each |v, k| {
			val := v?.toStr ?: "n/a"
			if (k.startsWith("---"))
				msg +=    "".padr(keySize + 1, '-') + " : $val\n"
			else
				msg += "$k ".padr(keySize + 1, '.') + " : $val\n"
		}

		return msg
	}
}
