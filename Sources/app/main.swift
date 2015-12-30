//
//  main.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

#if os(Linux)
    import Glibc
    import LinuxApp
#elseif os(OSX)
    import Darwin.C
    import Cocoa
    import OSXApp
#endif

func CreateApp() {
    
    let app = App()
#if os(Linux)
    
#elseif os(OSX)
    let application = NSApplication.sharedApplication()
    application.setActivationPolicy(NSApplicationActivationPolicy.Regular)
    application.delegate = app
    application.activateIgnoringOtherApps(true)
#endif
    app.run()
}


CreateApp()
