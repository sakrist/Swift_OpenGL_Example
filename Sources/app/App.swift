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
    import ndk.GLES3
#elseif os(Windows)
    import SwiftWin32
    import Win.GL
#endif

import SwiftMath
import GLApplication

class App: GLApplication.Application {
    
    // Scene variable, getter and setter.
    var scene:Scene { 
        get { 
            return self.renderObject as! Scene 
        } 
        set(scene) { 
            self.renderObject = scene    
        }        
    }
    
    var lastMousePoint = SwiftMath.Point()
    
    var pitch:Float = 0.0
    var yaw:Float = 0.0
    
    override func applicationCreate() {
        
        if isGLOn() {
            // create scene
            self.scene = Scene()
            scene.size = Size(640, 480)
            let rotateX = Matrix4x4f.rotate(x: Angle.init(radians: pitch))
            let rotateY = Matrix4x4f.rotate(y: Angle.init(radians: yaw))
            scene.modelViewMatrix = scene.modelViewMatrix * (rotateX * rotateY)
            scene.geometries.append(Cube())
            
            // re-draw after init
            self.needsDisplay()
        }
    }
    
    override func applicationClose() {
    
    }
    
    override func windowDidResize(_ size:SwiftMath.Size) {
        scene.size = size
    }
    
    // mouse events
    override func mouseDown(_ point:SwiftMath.Point, button:Int) {
        lastMousePoint = point
    }
    
    override func mouseMove(_ point:SwiftMath.Point) {

 
        
        let x = Float( (point.x - lastMousePoint.x) * scene.size.height/scene.size.width*0.5 )
        let y = Float( (point.y - lastMousePoint.y) * -(scene.size.width/scene.size.height*0.5) )
        
        pitch +=  -Angle.init(degrees:y).radians
        yaw += Angle.init(degrees:x).radians

        let rotateX = Matrix4x4f.rotate(x: Angle.init(radians: pitch))
        let rotateY = Matrix4x4f.rotate(y: Angle.init(radians: yaw))
        scene.modelViewMatrix = Matrix4x4f.translate(tx: 0, ty: 0, tz: -4) * (rotateX * rotateY)
        
        lastMousePoint = point
        
        needsDisplay()
    }
    
    override func mouseUp(_ point:SwiftMath.Point) {
        
    }
}



