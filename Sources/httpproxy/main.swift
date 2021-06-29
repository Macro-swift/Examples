#!/usr/bin/swift sh

import Macro // @Macro-swift
import Foundation
import Logging

// This actually fails mid-request w/ an early close:
// curl --proxy localhost:1337 http://www.mdlink.de

// Bump log level to trace
LoggingSystem.bootstrap { label in
  var handler = StreamLogHandler.standardOutput(label: label)
  handler.logLevel = .trace
  return handler
}

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
    req.log.trace("Responding:", proxiedResponse.status.code)
    res.writeHead(proxiedResponse.status,
                  headers: proxiedResponse.headers)
    
    // send proxied response body to the original client
    req.log.trace("Piping response ...")
    proxiedResponse
      .pipe(res)
      .onError { error in
        req.log.error("proxy response delivery failed:", error)
      }
      .onFinish {
        req.log.trace("Finished piping response.")
      }
  }
  .onError { error in
    req.log.error("proxy request delivery failed:", error)
    res.writeHead(500)
    res.end()
  }

  // Send the request body to the target server
  req.pipe(proxiedRequest)
    .onFinish {
      req.log.trace("Finished piping request.")
    }
}
.listen(1337) { server in
  server.log.log("Server listening on http://0.0.0.0:1337/")
}
.onError { error in
  console.error("Server error:", error)
}
