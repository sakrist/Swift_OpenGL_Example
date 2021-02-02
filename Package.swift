// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OpenGLExampleApp",
    dependencies: [
        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.3.0"),
        .package(url: "https://github.com/sakrist/GLAppBase", from: "0.0.3")
    ],
    targets: [
        .target( name: "app", dependencies: [ "SwiftMath", "GLAppBase" ]),
    ]    
)

 
#if os(Android) 
package.products.append(.library(name: "OpenGLExampleApp", type: .dynamic, targets: ["app"]))
package.dependencies.append(.package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", .exact("1.13.0")))
package.dependencies.append(.package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"))

package.targets[0].dependencies += ["AndroidLog", "CAndroidGL"]

package.targets += [
    .target(name: "AndroidLog", dependencies: ["CAndroidLog", .product(name: "Logging", package: "swift-log")]),
    .systemLibrary(name: "CAndroidLog"),
    .systemLibrary(name: "CAndroidGL")
]
#endif

#if os(Linux)
package.dependencies.append(.package(name: "COpenGL", url: "https://github.com/sakrist/COpenGL.swift.git", from:"1.0.7"))
package.dependencies.append(.package(name: "CX11", url: "https://github.com/sakrist/CX11.swift.git", from:"1.0.5"))
package.targets[0].dependencies += ["COpenGL", "CX11"]
#endif

