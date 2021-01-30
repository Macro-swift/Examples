import MacroExpress

/**
 * Work around bug in spec tool.
 *
 * The /specs/index.html sends (* separated for comment):
 *
 *   Content-Type: application/json
 *   Accept:       text/plain, * / *; q=0.01
 *
 * The tool essentially has the misconception that the API always returns
 * JSON regardless of the Accept header.
 */
func addAcceptJSON() -> Middleware {
  return { req, _, next in
    if req.is("application/json") {
      req.head.headers.replaceOrAdd(name: "Accept", value: "application/json")
    }
    next()
  }
}
