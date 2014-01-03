
internal const class ErrMsgs {

	static Str configNotFound(Str id) {
		"Config id '$id' does not exist"
	}

	static Str typeNotFacet(Type type) {
		"${type.qname}' is NOT a facet!?"
	}
	
	static Str facetDoesNotHaveId(Type facit) {
		"${facit.qname}' does not have a Str field named ID"
	}
	
}
