#!/usr/bin/swift sh
import Macro // @Macro-swift
import Foundation

// As with all "Macro*", this tries to replicate the Node.js APIs for Swift.
//
// A very basic Macro based (plain) HTTP proxy server. I.e. it doesn't do
// CONNECT tunneling (i.e. TLS/SSL), but just forward HTTP requests to another
// HTTP server using the Macro `http` module.

http.createServer { req, res in
  // log request
  req.log.log("\(req.method) \(req.url)")

  guard req.method != "CONNECT" else {
    req.log.error("Connect not supported.")
    res.writeHead(501)
    res.end()
    return
  }
  guard let url = URL(string: req.url),
        let scheme = url.scheme, let host = url.host else
  {
    req.log.error("Invalid URL:", req.url)
    res.writeHead(400)
    res.end()
    return
  }
  
  let options = http.ClientRequestOptions(
    headers  : req.headers, // TODO: Add 'Via' and such, drop the proper ones
    protocol : "\(scheme):",
    host     : host,
    method   : req.method,
    path     : url.path
  )
  
  let proxiedRequest = http.request(options) { proxiedResponse in
    res.writeHead(proxiedResponse.status,
                  headers: proxiedResponse.headers)
    
    // send proxied response body to the original client
    proxiedResponse
      .pipe(res)
      .onError { error in
        req.log.error("proxy response delivery failed:", error)
      }
  }
  .onError { error in
    req.log.error("proxy request delivery failed:", error)
    res.writeHead(500)
    res.end()
  }

  // Send the request body to the target server
  req.pipe(proxiedRequest)
}
.listen(1337) { server in
  server.log.log("Server listening on http://0.0.0.0:1337/")
}
