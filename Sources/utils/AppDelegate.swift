//
//  AppDelegate.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

public protocol AppDelegate {
    var renderObject: RenderObject? { get set }
    
    func applicationCreate()
    func applicationClose()
    
    func needsDisplay()
    
    func windowDidResize(size:Rect)
    
    func run()
}


public protocol MouseEventDelegate {
    func mouseDown(_ point:Point, button:Int)
    func mouseMove(_ point:Point)
    func mouseUp(_ point:Point)
}
