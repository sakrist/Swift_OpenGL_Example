
import PackageDescription

let package = Package(
    name: "opengl_example",
    targets: [
        Target( name: "core" ),
        Target( name: "app", dependencies: [ .Target(name: "core") ])
    ],
    dependencies: []
)


#if os(Linux)
package.dependencies.append(.Package(url: "https://github.com/sakrist/COpenGL.swift.git", majorVersion: 1))
package.dependencies.append(.Package(url: "https://github.com/sakrist/CX11.swift.git", majorVersion: 1))
    
let linuxTarget = Target( name: "LinuxApp", dependencies: [ .Target(name: "core") ])
package.targets.append(linuxTarget)
package.targets[1].dependencies.append(.Target(name: "LinuxApp"))
    
#elseif os(OSX)
    
let osxTarget = Target( name: "OSXApp", dependencies: [ .Target(name: "core") ])
package.targets.append(osxTarget)
package.targets[1].dependencies.append(.Target(name: "OSXApp"))
    
#endif
