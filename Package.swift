// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "opengl_example",
    dependencies: [],
    targets: [
        .target( name: "AppBase" ),
        .target( name: "app", dependencies: [ "AppBase" ])
    ]    
)


#if os(Linux)
package.dependencies.append(.package(url: "https://github.com/sakrist/COpenGL.swift.git", from:"1.0.5"))
package.dependencies.append(.package(url: "https://github.com/sakrist/CX11.swift.git", from:"1.0.3"))
#endif

