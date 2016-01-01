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

import utils


class App: AppBase {
    
    var scene:Scene { get { return self.renderObject as! Scene } set(scene) { self.renderObject = scene } }
    
    override func applicationCreate() {
        
        // create scene
        self.scene = Scene()
        
        scene.geometries.append(Cube())
        
        // re-draw after init
        self.needsDisplay()
    }
    
    override func applicationClose() {
    
    }
    
    override func windowDidResize(frame:Rect) {
        scene.size = frame.size
    }
    
    // mouse events
    override func mouseDown(point:Point, button:Int) {
    
    }
    
    override func mouseMove(point:Point) {
        scene.rotation += 0.1
        needsDisplay()
    }
    
    override func mouseUp(point:Point) {
        
    }
    
}


