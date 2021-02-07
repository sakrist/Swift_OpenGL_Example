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

import SGLMath
import GLApplication

class App: Application {
    
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
            
            let rotateX = SGLMath.rotate(mat4(1), pitch, vec3(1, 0, 0))
            let rotateXY = SGLMath.rotate(rotateX, yaw, vec3(0, 1, 0))
            scene.modelViewMatrix = scene.modelViewMatrix * rotateXY
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

        let xD = point.x - lastMousePoint.x
        let yD = point.y - lastMousePoint.y
        lastMousePoint = point
        
        if (xD > 40 || yD > 40) { return } // exit 
        
        let x = Float(xD) * Float(scene.size.height)/Float(scene.size.width) * 0.5 
        let y = Float(yD) * -Float(scene.size.width)/Float(scene.size.height) * 0.5 
        
        pitch +=  -radians(y)
        yaw += radians(x)

        let rotateX = SGLMath.rotate(mat4(1.0), pitch, vec3(1,0,0))
        let rotateXY = SGLMath.rotate(rotateX, yaw, vec3(0,1,0))
        scene.modelViewMatrix = SGLMath.translate(mat4(1), vec3(0,0,-4)) * rotateXY
        
        needsDisplay()
    }
    
    override func mouseUp(_ point:Point) {
        
    }
}



