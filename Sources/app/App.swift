//
//  App.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

#if os(Linux)
    import Glibc
#elseif os(OSX)
    import Darwin.C
#elseif os(iOS)
    import OpenGLES
#elseif os(Android)
    import Glibc
    import GL.ES3
#endif

import SwiftMath
import GLAppBase

class App: GLAppBase {
    
    // Scene variable, getter and setter.
    var scene:Scene { 
        get { 
            return self.renderObject as! Scene 
        } 
        set(scene) { 
            self.renderObject = scene    
        }        
    }
    
    var lastMousePoint:Point = Point()
    
    var pitch:Float = 0.3
    var yaw:Float = -0.4
    
    override func applicationCreate() {
        
        if isGLOn() {
            // create scene
            self.scene = Scene()
            scene.size = Size(640, 480)
            scene.modelViewMatrix *= (xRotation(pitch) * yRotation(yaw))
            scene.geometries.append(Cube())
            
            // re-draw after init
            self.needsDisplay()
        }
    }
    
    override func applicationClose() {
    
    }
    
    override func windowDidResize(_ size:Size) {
        scene.size = size
    }
    
    // mouse events
    override func mouseDown(_ point:Point, button:Int) {
        lastMousePoint = point
    }
    
    override func mouseMove(_ point:Point) {

 
        
        let x = Float( (point.x - lastMousePoint.x) * scene.size.height/scene.size.width*0.5 )
        let y = Float( (point.y - lastMousePoint.y) * -(scene.size.width/scene.size.height*0.5) )
        
        pitch +=  -degreesToRadians(y)
        yaw += degreesToRadians(x)

        scene.modelViewMatrix = translate(x:0, y:0, z:-4.0) * (xRotation(pitch) * yRotation(yaw))
        
        lastMousePoint = point
        
        needsDisplay()
    }
    
    override func mouseUp(_ point:Point) {
        
    }
}



