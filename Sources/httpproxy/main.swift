#!/usr/bin/swift sh

import Macro // @Macro-swift
import Foundation

http.createServer { req, res in
  // log request
  req.log.log("\(req.method) \(req.url)")

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
  _ = req.pipe(proxiedRequest)
}
.listen(1337) { server in
  console.log("Server listening on http://0.0.0.0:1337/")
}
