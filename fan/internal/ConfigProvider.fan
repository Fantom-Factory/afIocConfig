using afIoc::DependencyProvider
using afIoc::Inject
using afIoc::InjectionCtx
using afIoc::Registry

@NoDoc
const class ConfigProvider : DependencyProvider {
	
	@Inject
	private const Registry 	registry
	private const Type[] 	configFacets
	
	new make(Type[] configFacets, |This|in) {
		in(this)
		configFacets.each {
			if (!it.fits(Facet#))
				throw Err(ErrMsgs.typeNotFacet(it))
			id := it.field("id", false)
			if (id == null)
				throw Err(ErrMsgs.facetDoesNotHaveId(it))
			if (!id.type.fits(Str#) || id.isStatic)
				throw Err(ErrMsgs.facetDoesNotHaveId(it))
		}
		this.configFacets = configFacets
	}

	override Bool canProvide(InjectionCtx ctx) {
		getConfig(ctx) != null
	}

	override Obj? provide(InjectionCtx ctx) {
		config 	:= getConfig(ctx)
		id 		:= config.typeof.field("id").get(config) ?: ctx.field.name
		value 	:= configSource.get(id, ctx.dependencyType)
		return value
	}
	
	Facet? getConfig(InjectionCtx ctx) {
		ctx.fieldFacets.find |ff->Bool| { configFacets.any { it.fits(ff.typeof) } }
	}
	
	// lazily load configSource - it got no proxy 'cos of default values in mixin
	private IocConfigSource configSource() {
		registry.dependencyByType(IocConfigSource#)
	}
}
