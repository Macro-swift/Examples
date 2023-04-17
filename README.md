<h2>Macro.swift Examples
  <img src="http://zeezide.com/img/macro/MacroExpressIcon128.png"
       align="right" width="100" height="100" />
</h2>

A small, unopinionated "don't get into my way" / "I don't wanna `wait`" 
asynchronous web framework for Swift.
With a strong focus on replicating the Node APIs in Swift.
But in a typesafe, and fast way.

This repository contains examples for
[Macro.swift](https://github.com/Macro-swift/Macro).

### Running Examples as Scripts

Single file examples can be either run as scripts using 
[swift-sh](https://github.com/mxcl/swift-sh)
(install using a simple `brew install mxcl/made/swift-sh`),
from within Xcode or via `swift run`.

This also contains an example for deploying to AWS Lambda:
[express-simple-lambda](Sources/express-simple-lambda/).


## Examples

### [httpd-helloworld](Sources/httpd-helloworld)

Raw HTTP server w/o Express extras (middleware, templates).

```bash
$ Sources/httpd-helloworld/main.swift
2020-01-07T17:14:35+0100 notice: Server listening on http://localhost:1337/
```

Single source file:
```swift
#!/usr/bin/swift sh

import Macro // @Macro-swift

http.createServer { req, res in
    console.log("\(req.method) \(req.url)")
    res.writeHead(200, [ "Content-Type": "text/html" ])
    res.write("<h1>Hello Client: \(req.url)</h1>")
    res.write("<table><tbody>")
    for ( key, value ) in req.headers {
        res.write("<tr><td><nobr>\(key)</nobr></td><td>\(value)</td></tr>")
    }
    res.write("</tbody></table>")
    res.end()
}
.listen(1337) { server in
    console.log("Server listening on http://localhost:1337/")
}
```

### [express-simple](Sources/express-simple)

```bash
$ Sources/express-simple/main.swift
2020-06-03T14:58:59+0200 notice: Server listening on http://localhost:1337
```

Single source file with associated static resources and
[Mustache](https://github.com/AlwaysRightInstitute/mustache) 
templates. 
Forms, cookies, JSON, sessions, templates and cows - you get it all!

```swift
#!/usr/bin/swift sh

import MacroExpress // @Macro-swift
import cows         // @AlwaysRightInstitute

let app = express()
app.use(
  logger("dev"),
  bodyParser.urlencoded(),
  cookieParser(),
  session(),
  serveStatic(__dirname() + "/public")
)

// MARK: - Express Settings

app.set("view engine", "html") // really mustache, but we want to use .html
app.set("views", __dirname() + "/views")


// MARK: - Session View Counter

app.use { req, _, next in
    req.session["viewCount"] = req.session[int: "viewCount"] + 1
    next()
}
...

// MARK: - Cows

app.get("/cows") { req, res in
    res.send("<html><body><pre>\(cows.vaca())</pre></body></html>")
}

// MARK: - Main page

app.get("/") { req, res in
    let tagline = taglines.randomElement()!
  
    let values : [ String : Any ] = [
        "tagline"     : tagline,
        "viewCount"   : req.session["viewCount"] ?? 0,
        "cowOfTheDay" : cows.vaca()
    ]
    res.render("index", values)
}
...
```

Main index.html Mustache template, w/ header/footer templates:
```mustache
{{> header}}

  <p>
    Reload page for a new cow and tagline!
  </p>

  <pre style="border: 1px solid #DEDEDE; margin: 1em; padding: 0.5em;"
    >{{cowOfTheDay}}</pre>

  <div class="menu-centered">
    <ul class="menu">
      <li><a href="/form">Form Demo</a></li>
      <li><a href="https://github.com/Macro-swift">Macro.swift</a></li>
    </ul>
  </div>
    
{{> footer}}
```

Looks like this:
![MacroExpress Simple Screenshot](https://zeezide.de/img/macro/MacroExpressSimple.png)

There is an AWS Lambda variant of this (with minor adjustments):
[express-simple-lambda](Sources/express-simple-lambda/).

### [connect-static](Sources/connect-static)

Use the simpler `connect` module, instead of `express`. 
Probably no need to do this in the real world, just use MacroExpress.

Single source file with a static `index.html` plus images.

```bash
$ Sources/express-simple/main.swift
2021-01-30T16:16:17+0100 notice μ.console : Server listening on http://localhost:1337
```

### [todomvc](Sources/todomvc/)

A MacroExpress implementation of a [Todo-Backend](http://todobackend.com/), 
a simple JSON API to access and modify a list of todos.

```bash
$ swift run todomvc
2020-06-03T14:58:59+0200 notice: Server listening on http://localhost:1337
```

### [servedocc](Sources/servedocc/)

Macro server to serve "DocC" archives, a format to document Swift frameworks
and packages:
[Documenting a Swift Framework or Package](https://developer.apple.com/documentation/Xcode/documenting-a-swift-framework-or-package).

```bash
$ swift run servedocc SlothCreator.doccarchive
2021-06-26T17:14:08+0200 notice μ.console : Server listening on: http://localhost:1337/
2021-06-26T17:14:08+0200 notice μ.console : DocC Archive: /Users/helge/Downloads/SlothCreator.doccarchive
2021-06-26T17:14:13+0200 notice μ.console : GET /documentation/              200 - - 2   ms
```


## Who

**Macro** is brought to you by
[ZeeZide](http://zeezide.de).
We like 
[feedback](https://twitter.com/ar_institute), 
GitHub stars, 
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.

There is a `#microexpress` channel on the 
[Noze.io Slack](http://slack.noze.io/). Feel free to join!
