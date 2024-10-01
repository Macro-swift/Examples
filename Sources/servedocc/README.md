<h2>Macro.swift servedocc
  <img src="http://zeezide.com/img/macro/MacroExpressIcon128.png"
           align="right" width="100" height="100" />
</h2>

Macro server to serve "DocC" archives, a format to document Swift frameworks
and packages:
[Documenting a Swift Framework or Package](https://developer.apple.com/documentation/Xcode/documenting-a-swift-framework-or-package).

*Note*: This is for serving an exported documentation archive (`.doccarchive`),
not for building documentation from a DocC catalog.

## Usage

The server can be either run as a
[swift-sh](https://github.com/mxcl/swift-sh) script
(install using a simple `brew install mxcl/made/swift-sh`),
from within Xcode or via `swift run`.

### Via swift-sh

Example:
```bash
$ cd Sources/servedocc
$ ./main.swift ~/Downloads/SlothCreator.doccarchive
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
