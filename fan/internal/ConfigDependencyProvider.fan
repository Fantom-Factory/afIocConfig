using afIoc

@Js
internal const class ConfigDependencyProvider : DependencyProvider {
	
	// immutable funcs not available in JS
	// @Inject	private const |->ConfigSource| 	configSource
	
	@Inject	private const Scope	scope
	
	new make(|This|in) { in(this) }

	override Bool canProvide(Scope scope, InjectionCtx ctx) {
		if (ctx.isFieldInjection) {
			if (ctx.field.hasFacet(Config#))
				return true

			fieldDoc := ctx.field.doc
			if (fieldDoc != null && fieldDoc.contains("@config"))
				return true
		}
		return false
	}

	override Obj? provide(Scope scope, InjectionCtx ctx) {
		conSrc		:= (ConfigSource) scope.serviceById(ConfigSource#.qname)
		config		:= (Config?) ctx.field.facet(Config#, false)
		id 			:= config?.id ?: ctx.field.name
		// hasDefault() doesn't exist - see http://fantom.org/forum/topic/2507
//		optional	:= config.optional ?: (ctx.field.type.isNullable || ctx.field.hasDefault)
		optional	:= config?.optional ?: ctx.field.type.isNullable
		
		if (id != null)
			return conSrc.get(id, ctx.field.type, !optional)
		
		pod		:= ctx.field.parent.pod.name.decapitalize
		clazz	:= ctx.field.parent.name.decapitalize
		field	:= ctx.field.name.decapitalize
		
		qnames	:= "${field} ${pod}.${field} ${pod}.${clazz}.${field} ${clazz}.${field}".split
		name	:= qnames.find { conSrc.config.containsKey(it) }
		
		if (name == null)
			name = conSrc.config.keys.find { this.fromDisplayName(it).equalsIgnoreCase(field) }

		if (name == null) {
			if (optional)
				return null
			msg := "Could not determine config ID for field '${ctx.field.qname}' - tried " + qnames.join(", ") { "'${it}'" }
			throw ConfigNotFoundErr(msg, conSrc.config.keys)
		}

		value 	:= conSrc.get(name, ctx.field.type)
		return value
	}
	
	private Str fromDisplayName(Str name) {
		Str.fromChars(name.chars.findAll { it.isAlphaNum })
	}
}
