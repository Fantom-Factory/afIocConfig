
** As thrown by IocConfig.
const class IocConfigErr : Err {
	new make(Str msg := "", Err? cause := null) : super(msg, cause) {}
}
