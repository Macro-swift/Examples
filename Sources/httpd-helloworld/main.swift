#!/usr/bin/swift sh
import Macro // @Macro-swift

// As with all "Macro*", this tries to replicate the Node.js APIs for Swift.
//
// This is the lowest level HTTP server interface in Macro and is suitable for
// very basic HTTP servers that have no real routing needs.
// Most apps will rather use MacroExpress (or Connect as a middleground).

http.createServer { req, res in
    // Log request
    req.log.log("\(req.method) \(req.url)")

    // Set the response status to 200-OK and the "Content-Type" header to HTML
    res.writeHead(200, [ "Content-Type": "text/html" ])
    
    // Write some HTML
    res.write("<h1>Hello Client: \(req.url)</h1>")

    res.write("<table><tbody>")
    for ( key, value ) in req.headers {
        res.write("<tr><td><nobr>\(key)</nobr></td><td>\(value)</td></tr>")
    }
    res.write("</tbody></table>")

    // Mark the response as done, it is important to always call `end` at some
    // point to finish processing.
    res.end()
}
.listen(1337) { server in
    server.log.log("Server listening on http://*:1337/")
}
