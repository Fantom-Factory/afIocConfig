using afIoc::Inject
using afBeanUtils::TypeCoercer
using afBeanUtils::NotFoundErr

** (Service) - Provides the config values. 
@Js
const mixin ConfigSource {
	
	** Return the config value with the given id, optionally coercing it to the given type.
	** 
	** Throws 'ArgErr' if the ID could not be found.
	@Operator
	abstract Obj? get(Str id, Type? coerceTo := null, Bool checked := true)
	
	** Returns a case-insensitive map of all the config values
	abstract Str:Obj? config()

	** Returns a case-insensitive map suitable for logging. 
	** Same as 'config()' but without environment variables and duplicated env config.
	abstract Str:Obj? configMuted()

	** Properties defined with this prefix override those without. 
	** Example, if 'env' equals 'dev' and the given the config contains:
	** 
	**   acme.myProperty     = wot 
	**   dev.acme.myProperty = ever
	** 
	** Then the config 'acme.myProperty' would have the value 'ever'.
	** 
	** 'env' is set via the special config property 'afIocConfig.env'.
	abstract Str? env()
}

@Js
internal const class ConfigSourceImpl : ConfigSource {
	private  const TypeCoercer 	typeCoercer := TypeCoercer()
	override const Str:Obj? 	config
	override const Str:Obj? 	configMuted
	override const Str?			env

	new make(ConfigProvider[] configProviders, |This|in) {
		in(this)
		
		config := Str:Obj?[:] { caseInsensitive = true }
		configProviders.each {
			config.setAll(it.config)
		}
		
		this.env	= config["afIocConfig.env"].toStr.trimToNull
		
		// tidy up the config by removing env vars and overrides
		configMuted	:= config.dup
		envPrefix	:= (env ?: "") + "."
		envPrefixes	:= typeCoercer.coerce(config["afIocConfig.envs"], Str?#)?.toStr?.split(',')?.map { "${it}." } ?: Str#.emptyList
		config.each |val, key| {
			if (env != null && key.startsWith(envPrefix))
				configMuted[key[envPrefix.size..-1]] = val
			if (envPrefixes.any { key.startsWith(it) })
				configMuted.remove(key)
		}
		this.config = configMuted.toImmutable

		// remove environment variables from muted map
		Env.cur.vars.keys.each {
			// we could be removing useful stuff here - maybe have a re-think!? 
			configMuted.remove(it)
		}
		configMuted.remove("afIocConfig.env")
		configMuted.remove("afIocConfig.envs")
		this.configMuted = configMuted
	}
	
	override Obj? get(Str id, Type? coerceTo := null, Bool checked := true) {
		if (!config.containsKey(id))
			return checked ? throw ConfigNotFoundErr(ErrMsgs.configNotFound(id), config.keys) : null 
		value := config[id]
		if (value == null) 
			return null 
		if (coerceTo == null || value.typeof.fits(coerceTo))
			return value
		return typeCoercer.coerce(value, coerceTo)
	}	
}

** Thrown when a config ID has not been mapped.
@Js @NoDoc // we can't subclass ArgErr in JS - see http://fantom.org/forum/topic/2468
const class ConfigNotFoundErr : Err, NotFoundErr {
	override const Str?[]	availableValues
	override const Str		valueMsg	:= "Available Config IDs:"

	new make(Str msg, Obj?[] availableValues, Err? cause := null) : super(msg, cause) {
		this.availableValues = availableValues.map { it?.toStr }.sort
	}
	
	override Str toStr() {
		NotFoundErr.super.toStr		
	}
}