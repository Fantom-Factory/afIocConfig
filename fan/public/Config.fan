
** Use to inject config values into your classes. Example:
** 
**   syntax: fantom
**   @Config { id="gzipThreshold" }
**   private Int gzipThreshold
** 
** If 'id' is not provided, it is matched against a combination of field name, class name, and pod name. 
** See user guide for a complete description of the matching strategy. 
** 
@Js
facet class Config {
	** The id of the config value to be injected.
	** 
	** If 'null' then a matching strategy is utilised. 
	const Str? id
	
	// null is better than a 'def' value because IocConfig can never supply null, therefore there 
	// is never any ambiguity
	** 'optional' means an Err is **not** thrown if the config cannot be found.
	** Fields are not set if config could not be found. This lets 'optional' fields take default values.
	** 
	**   syntax: fantom
	**   @Config
	**   private Duration? timeToSelfDestruct := 10sec
	** 
	** If 'null' then it defaults to 'true' if the field is nullable.    
	const Bool? optional
}
