#!/usr/bin/swift sh
import MacroExpress // @Macro-swift

// As with all "Macro*", this tries to replicate the Node.js APIs for Swift.
//
// "Connect" is a middleground between just "Macro" (which provides a basic
// HTTP server) and "Express", which adds a lot on top of Connect.
// It provides a Middleware router, but not the mountable Route objects Express
// has.


// `__dirname` gives the directory location of the current Swift file, or
// fallbacks for binary setups.
// Here it is used to lookup static resources that live in the "public"
// directory alongside the Swift sources.
let dirname = __dirname()


// "connect" here provides an object which is used to attach middleware to the
// Macro HTTP server.
let app = connect()

// A builtin middleware that just logs incoming requests and the generated
// responses. "dev" is a logging config (others are "default", "short", "tiny").
app.use(logger("dev"))

// The builtin `serveStatic` middleware directly serves static resources to the
// browser. If it requests `/public/hello.gif`, this would serve the `hello.gif`
// file sitting in the `public` directory alongside the Swift sources.
app.use(serveStatic(__dirname() + "/public"))

// The only user middleware provided by this example - a simple redirect. If
// the browser hits `/` on the server, this will redirect to `/index.html`.
// In all other cases, it will continue processing (by calling the `next`
// function, which essentially says "I don't handle this, continue with the
// next middleware attached" - while will be the default 404).
// Note that this middleware runs after the `serveStatic` above, which already
// handles all static files in the `public` directory (including `index.html`).
app.use { req, res, next in
    guard req.url == "/" else { return next() }
    res.redirect("/index.html")
}

// This starts the webserver on port 1337. It will process the middleware
// attached using the functions above.
app.listen(1337) {
    console.log("Server listening on http://localhost:1337")
}
