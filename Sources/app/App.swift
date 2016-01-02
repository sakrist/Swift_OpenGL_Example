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
    
    var lastMousePoint:Point = Point()
    
    var pitch:Float = 0.3
    var yaw:Float = -0.4
    
    override func applicationCreate() {
        
        // create scene
        self.scene = Scene()
        scene.size = Size(640, 480)
        scene.modelViewMatrix *= (xRotation(pitch) * yRotation(yaw))
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
        lastMousePoint = point
    }
    
    override func mouseMove(point:Point) {

        // trackball rotation, does not work really well
//        let trackBallSize:Float = Float((scene.size.width + scene.size.height)/2)
//        let q:quat = trackball(start:lastMousePoint, end:point, trackSize: trackBallSize)
//        let trackballRotation = rotationMatrix(q)
//        scene.modelViewMatrix *= trackballRotation

        
        let x = Float( (point.x - lastMousePoint.x) * scene.size.height/scene.size.width*0.5 )
        let y = Float( (point.y - lastMousePoint.y) * -(scene.size.width/scene.size.height*0.5) )
        
        pitch +=  -degreesToRadians(y)
        yaw += degreesToRadians(x)

        scene.modelViewMatrix = translate(x:0, y:0, z:-4.0) * (xRotation(pitch) * yRotation(yaw))
        
        lastMousePoint = point
        
        needsDisplay()
    }
    
    override func mouseUp(point:Point) {
        
    }
    
}


