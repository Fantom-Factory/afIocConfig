
** Use to inject config values into your classes. Example:
** 
**   syntax: fantom
** 
**   @Config { id="gzipThreshold" }
**   private Int gzipThreshold
** 
** If 'id' is not provided, it takes on the name of the field. Therefore the following is identical to the above:
** 
**   syntax: fantom
** 
**   @Config
**   private Int gzipThreshold
** 
facet class Config {
	** The id of the config value to be injected.
	const Str? id := null
	
	// null is better than a 'def' value because IocConfig can never supply null, therefore there 
	// is never any ambiguity 
	** If 'true' and the config id cannot be found then 'null' is returned and an Err is not thrown.
	** 
	** Just ensure the field is 'nullable'!
	const Bool optional := false
}
