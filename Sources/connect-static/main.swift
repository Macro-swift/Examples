#!/usr/bin/swift sh

import Foundation
import MacroExpress // @Macro-swift ~> 0.0.3

let dirname = __dirname()

let app = connect()

app.use(logger("dev"))
app.use(serveStatic(__dirname() + "/public"))

app.use { req, res, next in
  guard req.url == "/" else { return next() }
  res.redirect("/index.html")
}

app.listen(1337) {
    console.log("Server listening on http://localhost:1337")
}
