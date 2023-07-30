// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "OpenGLExampleApp",
    products: [
        .library(name: "OpenGLExampleApp", type: .dynamic, targets: ["app"])
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.3.1"),
        .package(url: "https://github.com/sakrist/GLApplication", branch: "main"),
        .package(url: "https://github.com/sakrist/AndroidNDK", branch: "main")
    ],
    targets: [
        .executableTarget(name: "app",
                dependencies: [ "SwiftMath", "GLApplication", "AndroidNDK" ], 
                cSettings: [.define("GL_GLEXT_PROTOTYPES")])
    ]
)


