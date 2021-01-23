//
//  main_android.swift
//  Swift_OpenGL_Example
//
//  Created by Volodymyr Boichentsov on 01/06/2019.
//
//

#if os(Android)
import Foundation
import GLAppBase
import Android.log

var app:App?

func os_log(_ string:String) {
    let cstr = string.cString(using: String.Encoding.utf8)
    print_log(cstr)
}

@_cdecl("Java_com_home_Swift_1OpenGL_1Example_SwiftApp_applicationCreate")
public func applicationCreate() -> Int32 {
    os_log("applicationCreate")
    if (app == nil) {
        app = App()
        app!.applicationCreate()
        return ( isGLOn() ? 1 : 0 )
    }
    return 0
}

@_cdecl("Java_com_home_Swift_1OpenGL_1Example_SwiftApp_needsDisplay")
public func needsDisplay() {
   app?.needsDisplay()
}

@_cdecl("Java_com_home_Swift_1OpenGL_1Example_SwiftApp_windowDidResize")
public func windowDidResize(w:Int32, h:Int32) {
    let size = Size(w, h)
    app?.windowDidResize(size)
        
    os_log("windowDidResize \(size)")
}


@_cdecl("Java_com_home_Swift_1OpenGL_1Example_SwiftApp_pointerDown")
public func pointerDown(x:Int32, y:Int32) {
    app?.mouseDown(Point(x, y), button:0)
}

@_cdecl("Java_com_home_Swift_1OpenGL_1Example_SwiftApp_pointerMove")
public func pointerMove(x:Int32, y:Int32) {
    app?.mouseMove(Point(x, y))
}

@_cdecl("Java_com_home_Swift_1OpenGL_1Example_SwiftApp_pointerUp")
public func pointerUp(x:Int32, y:Int32) {
    app?.mouseUp(Point(x, y))
}


#endif


