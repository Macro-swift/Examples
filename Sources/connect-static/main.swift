#!/usr/bin/swift sh

import Foundation
import MacroExpress // @Macro-swift ~> 0.0.2

let dirname = __dirname()

let app = connect()

app.use { req, _, next in
  print("request:", req.url)
  next()
}

app.use(logger("dev")) // Middleware: logs the request

let servePath = __dirname() + "/public"
console.log("serving:", servePath)
app.use(serveStatic(__dirname() + "/public"))

app.listen(1337) {
    console.log("Server listening on http://localhost:1337/")
}
