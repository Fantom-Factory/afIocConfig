using afIoc::DependencyProvider
using afIoc::Inject
using afIoc::InjectionCtx
using afIoc::Registry

internal const class ConfigProvider : DependencyProvider {
	
	@Inject	private const Registry 	registry
	
	new make(|This|in) { in(this) }

	override Bool canProvide(InjectionCtx ctx) {
		ctx.field != null && ctx.field.hasFacet(Config#)
	}

	override Obj? provide(InjectionCtx ctx) {
		conSrc	:= configSource
		config	:= (Config) Field#.method("facet").callOn(ctx.field, [Config#])	// Stoopid F4
		id 		:= config.id
		
		if (id != null)
			return conSrc.get(id, ctx.dependencyType, !config.optional)
		
		pod		:= ctx.field.parent.pod.name.decapitalize
		clazz	:= ctx.field.parent.name.decapitalize
		field	:= ctx.field.name.decapitalize
		
		qnames	:= "${field} ${pod}.${field} ${pod}.${clazz}.${field} ${clazz}.${field}".split
		name	:= qnames.find { conSrc.config.containsKey(it) }
		
		if (name == null)
			name = conSrc.config.keys.find { this.fromDisplayName(it).equalsIgnoreCase(field) }

		if (name == null)
			return config.optional ? null : throw ConfigNotFoundErr(ErrMsgs.couldNotDetermineId(ctx.field, qnames), conSrc.config.keys)

		value 	:= conSrc.get(name, ctx.dependencyType)
		return value
	}
	
	private Str fromDisplayName(Str name) {
		Str.fromChars(name.chars.findAll { it.isAlphaNum })
	}
	
	** lazily load configSource - can't be arsed proxy'ing it!
	private ConfigSource configSource() {
		registry.serviceById(ConfigSource#.qname)
	}
}
