using afIoc::DependencyProvider
using afIoc::Inject
using afIoc::InjectionCtx
using afIoc::Registry

internal const class ConfigProvider : DependencyProvider {
	
	@Inject
	private const Registry registry
	
	new make(|This|in) { in(this) }

	override Bool canProvide(InjectionCtx ctx) {
		!ctx.fieldFacets.findType(Config#).isEmpty
	}

	override Obj? provide(InjectionCtx ctx) {
		configs	:= ctx.fieldFacets.findType(Config#)
		if (configs.size > 1)
			throw Err("WTF")

		config 	:= (Config) configs.first
		id 		:= config.id ?: ctx.field.name
		value 	:= configSource.get(id, ctx.dependencyType)
		return value
	}
	
	// lazily load configSource - it got no proxy 'cos of default values in mixin
	private IocConfigSource configSource() {
		registry.dependencyByType(IocConfigSource#)
	}
}
