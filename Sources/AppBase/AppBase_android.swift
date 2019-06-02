//
//  AppBase.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

#if os(Android)
import Foundation


open class AppBase {
    public var renderObject: RenderObject?
    
    public init() { }
    
    open func run() { }
    
    open func applicationCreate() {}
    open func applicationClose() {}
    
    open func needsDisplay() { }

    open func windowDidResize(_ size:Size) {}
    
    // MouseEventDelegate
    
    open func mouseDown(_ point:Point, button:Int) {}
    open func mouseMove(_ point:Point) {}
    open func mouseUp(_ point:Point) {}
    
}
    
#endif

