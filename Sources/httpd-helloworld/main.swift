#!/usr/bin/swift sh

import Macro // @Macro-swift ~> 0.0.2

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
.listen(1337) { server in
    console.log("Server listening on http://localhost:1337/")
}
