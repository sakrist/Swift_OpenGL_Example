
import PackageDescription

let package = Package(
    name: "opengl_example",
    targets: [
        Target( name: "AppBase" ),
        Target( name: "app", dependencies: [ .Target(name: "AppBase") ])
    ],
    dependencies: []
)


#if os(Linux)
package.dependencies.append(.Package(url: "https://github.com/sakrist/COpenGL.swift.git", majorVersion: 1))
package.dependencies.append(.Package(url: "https://github.com/sakrist/CX11.swift.git", majorVersion: 1))
#endif

