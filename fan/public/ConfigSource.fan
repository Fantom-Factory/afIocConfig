using afIoc::Inject
using afBeanUtils::TypeCoercer
using afBeanUtils::NotFoundErr

** (Service) - Provides the config values. 
const mixin ConfigSource {
	
	** Return the config value with the given id, optionally coercing it to the given type.
	** 
	** Throws 'ArgErr' if the ID could not be found.
	@Operator
	abstract Obj? get(Str id, Type? coerceTo := null, Bool checked := true)
	
	** Returns a case-insensitive map of all the config values
	abstract Str:Obj? config()
}

internal const class ConfigSourceImpl : ConfigSource {
	private const TypeCoercer typeCoercer := CachingTypeCoercer()

			override const Str:Obj? config
	@Inject	private const FactoryDefaults		factoryDefaults
	@Inject	private const ApplicationDefaults	applicationDefaults

	new make(|This|in) {
		in(this)
		config := Str:Obj?[:] { caseInsensitive = true }
		config.setAll(factoryDefaults.config)
		config.setAll(applicationDefaults.config)
		this.config = config.toImmutable
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
@NoDoc
const class ConfigNotFoundErr : ArgErr, NotFoundErr {
	override const Str?[]	availableValues
	override const Str		valueMsg	:= "Available Config IDs:"

	new make(Str msg, Obj?[] availableValues, Err? cause := null) : super(msg, cause) {
		this.availableValues = availableValues.map { it?.toStr }.sort
	}
	
	override Str toStr() {
		NotFoundErr.super.toStr		
	}
}