using afIoc::Inject
using afBeanUtils::TypeCoercer
using afBeanUtils::NotFoundErr

** (Service) - Provides the config values. 
const mixin IocConfigSource {
	
	** Return the config value with the given id, optionally coercing it to the given type.
	@Operator
	abstract Obj? get(Str id, Type? coerceTo := null)
	
	** Returns a case-insensitive map of all the config values
	abstract Str:Obj? config()
	
}

internal const class IocConfigSourceImpl : IocConfigSource {
	private const TypeCoercer typeCoercer := CachingTypeCoercer()

	override const Str:Obj? config

	@Inject  
	private const FactoryDefaults	factoryDefaults

	@Inject  
	private const ApplicationDefaults	applicationDefaults

	new make(|This|in) {
		in(this)
		config := factoryDefaults.config.rw
		config.setAll(applicationDefaults.config)
		this.config = config.toImmutable
	}
	
	override Obj? get(Str id, Type? coerceTo := null) {
		if (!config.containsKey(id))
			throw ConfigNotFoundErr(ErrMsgs.configNotFound(id), config.keys)
		value := config[id]
		if (value == null) 
			return null 
		if (coerceTo == null || value.typeof.fits(coerceTo))
			return value
		return typeCoercer.coerce(value, coerceTo)
	}	
}

** Thrown when a config ID has not been mapped.
const class ConfigNotFoundErr : Err, NotFoundErr {
	override const Str?[] availableValues
	
	new make(Str msg, Obj?[] availableValues, Err? cause := null) : super(msg, cause) {
		this.availableValues = availableValues.map { it?.toStr }.sort
	}
	
	override Str toStr() {
		NotFoundErr.super.toStr		
	}
}