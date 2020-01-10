// swift-tools-version:5.0

import PackageDescription

let package = Package(
  
  name: "MacroExamples",

  platforms: [
    .macOS(.v10_14), .iOS(.v11)
  ],
  
  products: [
    .executable(name: "httpd-helloworld", targets: [ "httpd-helloworld" ]),
    .executable(name: "connect-static",   targets: [ "connect-static"   ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Macro-swift/Macro.git",
             from: "0.0.12"),
             /*
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "0.0.2")
             */
    .package(url: "file:///Users/helge/dev/Swift/Macro/MacroExpress",
             .branch("develop"))
  ],
  
  targets: [
    .target(name: "httpd-helloworld", dependencies: [ "Macro"        ]),
    .target(name: "connect-static",   dependencies: [ "MacroExpress" ])
  ]
)
