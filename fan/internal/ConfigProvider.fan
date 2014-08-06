using afIoc::DependencyProvider
using afIoc::Inject
using afIoc::InjectionCtx
using afIoc::Registry

internal const class ConfigProvider : DependencyProvider {
	
	@Inject
	private const Registry 	registry
	
	new make(|This|in) { in(this) }

	override Bool canProvide(InjectionCtx ctx) {
		ctx.field != null && ctx.field.hasFacet(Config#)
	}

	override Obj? provide(InjectionCtx ctx) {
		conSrc	:= configSource
		config	:= (Config) Field#.method("facet").callOn(ctx.field, [Config#])	// Stoopid F4
		id 		:= config.id
		
		if (id != null)
			return conSrc.get(id, ctx.dependencyType)
		
		pod		:= ctx.field.parent.pod.name.decapitalize
		clazz	:= ctx.field.parent.name.decapitalize
		field	:= ctx.field.name.decapitalize
		
		qnames	:= "${field} ${pod}.${field} ${pod}.${clazz}.${field} ${clazz}.${field}".split
		name	:= qnames.find { conSrc.config.containsKey(it) } ?: throw ConfigNotFoundErr(ErrMsgs.couldNotDetermineId(ctx.field, qnames), conSrc.config.keys)
		value 	:= conSrc.get(name, ctx.dependencyType)
		return value
	}
	
	** lazily load configSource - it got no proxy 'cos of default values in mixin
	private ConfigSource configSource() {
		registry.dependencyByType(ConfigSource#)
	}
}
