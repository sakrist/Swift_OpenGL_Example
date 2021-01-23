//
//  main.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

// This file only for macOS and iOS

#if os(Linux)
    import Glibc
#elseif os(OSX)
    import Darwin.C
    import Cocoa
#endif


#if os(Linux) || os(macOS)
import GLAppBase
func main() {    
    let app = App()
    app.run()
    
}
main()

#elseif os(iOS)
import UIKit
UIApplicationMain( CommandLine.argc,
                   CommandLine.unsafeArgv,
                   nil,
                   NSStringFromClass(App.self))
#endif

