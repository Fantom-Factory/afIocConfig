
** Use with '@Inject' to inject config values into your classes. Example:
** 
** @Inject @Config { "afBedSheet.gzip.threshold" }
** private Int gzipThreshold
facet class Config {
	const Str? id := null
}
