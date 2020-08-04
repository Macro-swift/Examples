// swift-tools-version:5.0

import PackageDescription

let package = Package(
  
  name: "MacroExamples",

  platforms: [
    .macOS(.v10_14), .iOS(.v11)
  ],
  
  products: [
    .executable(name: "httpd-helloworld", targets: [ "httpd-helloworld" ]),
    .executable(name: "connect-static",   targets: [ "connect-static"   ]),
    .executable(name: "express-simple",   targets: [ "express-simple"   ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Macro-swift/Macro.git",
             from: "0.5.4"),
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "0.5.4"),
    .package(url: "https://github.com/AlwaysRightInstitute/cows",
             from: "1.0.0")
  ],
  
  targets: [
    .target(name: "httpd-helloworld", dependencies: [ "Macro"        ]),
    .target(name: "connect-static",   dependencies: [ "MacroExpress" ]),
    .target(name: "express-simple",   dependencies: [ "MacroExpress", "cows" ])
  ]
)
