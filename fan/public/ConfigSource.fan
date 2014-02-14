using afIoc::ConcurrentState
using afIoc::Inject
using afIoc::NotFoundErr
using afIoc::TypeCoercer

** (Service) - Provides the config values. 
const mixin IocConfigSource {
	
	** Return the config value with the given id, optionally coercing it to the given type.
	@Operator
	abstract Obj? get(Str id, Type? coerceTo := null)
	
	** Returns a case-insensitive map of all the config values
	abstract Str:Obj? config()
	
}

internal const class IocConfigSourceImpl : IocConfigSource {
	private const ConcurrentState 	conState	:= ConcurrentState(TypeCoercer#)

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
			throw NotFoundErr(ErrMsgs.configNotFound(id), config.keys)
		value := config[id]
		if (value == null) 
			return null 
		if (coerceTo == null || value.typeof.fits(coerceTo))
			return value
		return conState.getState() |TypeCoercer typeCoercer -> Obj?| { typeCoercer.coerce(value, coerceTo) }
	}	
}
