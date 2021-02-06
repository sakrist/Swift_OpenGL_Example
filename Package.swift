// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OpenGLExampleApp",
    dependencies: [
//        .package(path: "../SwiftMath"),
//        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.3.0"),
        .package(url: "https://github.com/sakrist/SwiftMath", .branch("feature/matrix3x3-tests")),
        .package(url: "https://github.com/sakrist/GLApplication", from: "0.0.4")
        //.package(url: "https://github.com/sakrist/GLAppBase", .branch("feature/build-with-spm"))
    ],
    targets: [
        .target(name: "app", 
                dependencies: [ "SwiftMath", "GLApplication" ], 
                cSettings: [.define("GL_GLEXT_PROTOTYPES")]),
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

