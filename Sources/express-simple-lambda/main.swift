#!/usr/bin/swift sh
import MacroLambda // @Macro-swift
import cows        // @AlwaysRightInstitute

// As with all "Macro*", this tries to replicate the Node.js APIs for Swift.
//
// This is a little more complex Express.js like example specifically for
// MacroLambda, aka running Macro in AWS Lambda. Featuring
// - cooking parsing,
// - static resource delivery,
// - Mustache template rendering,
// - Express middleware.

let app = express()

app.use(
    logger("dev"),
    bodyParser.urlencoded(),
    cookieParser(),
    serveStatic(__dirname() + "/public")
)

// MARK: - Express Settings

app.set("view engine", "html") // really mustache, but we want to use .html
app.set("views", __dirname() + "/views")


// MARK: - Routes

let taglines = [
    "Less than Perfect.",
    "Das Haus das Verrückte macht.",
    "Rechargeables included",
    "Sensible Server Side Swift aS a Successful Software Service Solution"
]


// MARK: - Form Handling

app.get("/form") { _, res in
    res.render("form")
}
app.post("/form") { req, res in
    let user = req.body[string: "u"]
    console.log("USER IS: \(user)")
  
    let options : [ String : Any ] = [
        "user"      : user,
        "nouser"    : user.isEmpty,
        "viewCount" : req.session["viewCount"] ?? 0
    ]
    res.render("form", options)
}


// MARK: - JSON & Cookies

app.get("/json") { _, res in
    res.json([
        [ "firstname": "Donald",   "lastname": "Duck" ],
        [ "firstname": "Dagobert", "lastname": "Duck" ]
    ])
}

app.get("/cookies") { req, res in
    // returns all cookies as JSON
    res.json(req.cookies)
}


// MARK: - Cows

app.get("/cows") { _, res in
    res.send("<html><body><pre>\(cows.vaca())</pre></body></html>")
}


// MARK: - Main page

app.get("/") { req, res in
    let tagline = taglines.randomElement()!
  
    let values : [ String : Any ] = [
        "tagline"     : tagline,
        "cowOfTheDay" : cows.vaca()
    ]
    res.render("index", values)
}


// MARK: - Start Server

#if false // use this, if you want to use the Lambda server emulation (JSON!)
  import func Foundation.setenv
  if process.isRunningInXCode {
    // Enable Lambda emulation when running locally.
    setenv("LOCAL_LAMBDA_SERVER_ENABLED", "true", 1)
  }
#endif

if process.isRunningInLambda {
  Lambda.run(app)
}
else {
  app.listen(1337) {
    console.log("Server listening on http://localhost:1337")
  }
}
