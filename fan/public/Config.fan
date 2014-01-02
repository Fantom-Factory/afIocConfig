
** Use with '@Inject' to inject config values into your classes. Example:
** 
**   @Inject @Config { id="gzipThreshold" }
**   private Int gzipThreshold
** 
** If id is not provided, it takes on the name of the field. Therefore the following is identical to the above:
** 
**   @Inject @Config
**   private Int gzipThreshold
** 
facet class Config {
	** The id of the config value to be injected.
	const Str? id := null
}
