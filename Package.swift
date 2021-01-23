// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "OpenglExample",
    dependencies: [
        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.2.2"),
        .package(url: "https://github.com/sakrist/GLAppBase", from: "0.0.1")
    ],
    targets: [
        .target( name: "app", dependencies: [ "SwiftMath", "GLAppBase" ])
    ]    
)


#if os(Linux)
package.dependencies.append(.package(url: "https://github.com/sakrist/COpenGL.swift.git", from:"1.0.5"))
package.dependencies.append(.package(url: "https://github.com/sakrist/CX11.swift.git", from:"1.0.3"))
#endif

