using afIoc

internal const class ConfigDependencyProvider : DependencyProvider {
	
	@Inject	private const |->ConfigSource| 	configSource
	
	new make(|This|in) { in(this) }

	override Bool canProvide(Scope scope, InjectionCtx ctx) {
		ctx.isFieldInjection && ctx.field.hasFacet(Config#)
	}

	override Obj? provide(Scope scope, InjectionCtx ctx) {
		conSrc	:= (ConfigSource) configSource()
		config	:= (Config) Field#.method("facet").callOn(ctx.field, [Config#])	// Stoopid F4
		id 		:= config.id
		
		if (id != null)
			return conSrc.get(id, ctx.field.type, !config.optional)
		
		pod		:= ctx.field.parent.pod.name.decapitalize
		clazz	:= ctx.field.parent.name.decapitalize
		field	:= ctx.field.name.decapitalize
		
		qnames	:= "${field} ${pod}.${field} ${pod}.${clazz}.${field} ${clazz}.${field}".split
		name	:= qnames.find { conSrc.config.containsKey(it) }
		
		if (name == null)
			name = conSrc.config.keys.find { this.fromDisplayName(it).equalsIgnoreCase(field) }

		if (name == null)
			return config.optional ? null : throw ConfigNotFoundErr(ErrMsgs.couldNotDetermineId(ctx.field, qnames), conSrc.config.keys)

		value 	:= conSrc.get(name, ctx.field.type)
		return value
	}
	
	private Str fromDisplayName(Str name) {
		Str.fromChars(name.chars.findAll { it.isAlphaNum })
	}
}
