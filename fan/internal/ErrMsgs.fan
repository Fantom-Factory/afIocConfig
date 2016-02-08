
@Js
internal const class ErrMsgs {

	static Str configNotFound(Str id) {
		"Config id '$id' does not exist"
	}	

	static Str couldNotDetermineId(Field field, Str[] names) {
		"Could not determine config ID for field '${field.qname}' - tried " + names.join(", ") { "'${it}'" }
	}	
}
