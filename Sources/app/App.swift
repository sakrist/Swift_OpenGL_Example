//
//  App.swift
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
    import OSXApp
#endif
    
    
class App: AppBase {
    
    override func applicationCreate() {
    
        self.renderObject = Scene()
     
    }
    
    override func applicationClose() {
    
    }
    
}


