<h2>Macro.swift httpd-helloworld
  <img src="http://zeezide.com/img/MicroExpressIcon1024.png"
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

### Who

**Macro** is brought to you by
the
[Always Right Institute](http://www.alwaysrightinstitute.com)
and
[ZeeZide](http://zeezide.de).
We like 
[feedback](https://twitter.com/ar_institute), 
GitHub stars, 
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.

There is a `#microexpress` channel on the 
[Noze.io Slack](http://slack.noze.io/). Feel free to join!
