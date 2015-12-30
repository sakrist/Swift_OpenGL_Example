//
//  Scene.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

#if os(Linux)
    import Glibc
    import COpenGL.gl
#elseif os(OSX)
    import Darwin.C
    import Cocoa
#endif

import core

class Scene: RenderObject {
    func render() {
    
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        let color = (Float(random() % 255))/255.0
        glClearColor(color, color, color, 1.0)
        
    }
}
