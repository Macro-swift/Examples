<h2>Macro.swift httpd-helloworld
  <img src="http://zeezide.com/img/macro/MacroExpressIcon128.png"
       align="right" width="100" height="100" />
</h2>

Demonstrates the use of the basic `http` module.
That doesn't feature any middleware or such, but
just the basic request/response mechanism.

The server take a client request and returns an HTML response
with some information about the submitted request.

Like in Node, IncomingMessage and ServerResponse
are regular streams.

## Running the Sample

If you have
[swift-sh](https://github.com/mxcl/swift-sh)
installed (`brew install swift-sh`),
just starting the main.swift file works:
```
$ Sources/httpd-helloworld/main.swift
2020-01-07T17:14:35+0100 notice: Server listening on http://localhost:1337/
```

Or you can use `swift run` w/o installing additional software:
```
$ swift run httpd-helloworld
2020-01-07T21:37:05+0100 notice: Server listening on http://localhost:1337/
```

## Source

```swift
#!/usr/bin/swift sh

import Macro // @Macro-swift ~> 0.5.4
http.createServer { req, res in
    // log request
    console.log("\(req.method) \(req.url)")

    // set content type to HTML
    res.writeHead(200, [ "Content-Type": "text/html" ])
    
    // write some HTML
    res.write("<h1>Hello Client: \(req.url)</h1>")

    res.write("<table><tbody>")
    for ( key, value ) in req.headers {
        res.write("<tr><td><nobr>\(key)</nobr></td><td>\(value)</td></tr>")
    }
    res.write("</tbody></table>")

    // finish up
    res.end()
}
.listen(1337, "0.0.0.0") { server in
    console.log("Server listening on http://0.0.0.0:1337/")
}
```

### Who

**Macro** is brought to you by
[ZeeZide](http://zeezide.de).
We like 
[feedback](https://twitter.com/ar_institute), 
GitHub stars, 
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.

There is a `#microexpress` channel on the 
[Noze.io Slack](http://slack.noze.io/). Feel free to join!
