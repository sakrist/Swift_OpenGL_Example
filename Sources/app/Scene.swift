//
//  Scene.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

#if os(Linux)
    import Glibc
    import OpenGL
#elseif os(OSX)
    import Darwin.C
    import Cocoa
    import OpenGL
    import simd
#elseif os(iOS)
    import OpenGLES
#elseif os(Android)
    import Glibc
    import ndk.GLES3
#elseif os(Windows)
    import Win.GL
#endif

import GLApplication
import SwiftMath

extension Matrix4x4f {
    
    func extract() -> Matrix3x3f {
        let P = self[0].xyz
        let Q = self[1].xyz
        let R = self[2].xyz
        return Matrix3x3f.init(P, Q, R)
    }
}



public class Scene: RenderObject {
    
    var shader:Shader!
    
    var geometries:[Geometry] = []
    
    var modelViewProjectionMatrix = Matrix4x4f.identity
    var modelViewMatrix = Matrix4x4f.identity
    var projectionMatrix = Matrix4x4f.identity
    
    var normalMatrix = Matrix3x3f.identity
    
    var fovAngle:Float = 65.0
    var farZ:Float = 100.0
    var nearZ:Float = 0.1
    
    var size:Size = Size(640, 480) {
        didSet {
            let aspect = fabsf(Float(size.width / size.height))
            let angle = Angle.init(degrees: fovAngle)
            
            let height = 1.0 / tan(angle * 0.5)
            let width  = height * 1.0/aspect;
            
            projectionMatrix = Matrix4x4f.projRH(x:0, y:0, 
                                                 w:width, h:height, 
                                                 near: nearZ, far: farZ)
        }
    }
    
    init() {
        
        // init shader
        self.shader = Shader(vertexShader:vertexShader, fragmentShader:fragmentShader)
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        modelViewMatrix = Matrix4x4f.translate(tx:0, ty:0, tz:-4.0)
        
        update()
    }
    
    func update() {
        
        modelViewProjectionMatrix = projectionMatrix * modelViewMatrix
        
        normalMatrix = modelViewMatrix.extract()
        normalMatrix = normalMatrix.inversed
        normalMatrix = normalMatrix.transposed
        
    }
    
    public func render() {
        
        update()
        
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glClearColor(0.65, 0.65, 0.65, 1.0)
        
        // Use shader
        shader.use()

        withUnsafePointer(to: &modelViewProjectionMatrix, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(shader.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, $0)
            })
        })

        withUnsafePointer(to: &normalMatrix, {
            $0.withMemoryRebound(to: Float.self, capacity: 9, {
                glUniformMatrix3fv(shader.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, $0)
            })
        })
        
        // Draw objects
        for g in geometries {
            g.draw()
        }
    }
}


var vertexShader = "#version 000  \n"
    + "// macroses \n"
    + "\n"
    + "#if defined(GL_ES)\n"
    + "precision highp float;\n"
    + "#endif\n"
    + "#if version>130 \n"
    + "#define attribute in \n"
    + "#define varying out \n"
    + "#endif \n"
    + "\n"
    + "attribute vec4 position;\n"
    + "attribute vec3 normal;\n"
    + "\n"
    + "varying vec4 colorVarying;\n"
    + "\n"
    + "uniform mat4 modelViewProjectionMatrix;\n"
    + "uniform mat3 normalMatrix;\n"
    + "\n"
    + "void main()\n"
    + "    {\n"
    + "        vec3 eyeNormal = normalize(normalMatrix * normal);\n"
    + "        vec3 lightPosition = vec3(0.0, 0.0, 1.0);\n"
    + "        vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);\n"
    + "\n"
    + "        float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));\n"
    + "\n"
    + "        colorVarying = diffuseColor * nDotVP;\n"
    + "\n"
    + "        gl_Position = modelViewProjectionMatrix * position;\n"
    + "}\n  "


var fragmentShader = "#version 000\n"
    + "// macroses \n"
    + "\n"
    + "#if defined(GL_ES)\n"
    + "precision mediump float;\n"
    + "#endif\n"
    + "\n"
    + "#if version>130 \n"
    + "#define varying in \n"
    + "out vec4 glFragData0;\n"
    + "#else\n"
    + "#define glFragData0 gl_FragColor \n"
    + "#endif \n"
    + "\n"
    + "varying vec4 colorVarying;\n"
    + "\n"
    + "void main()\n"
    + "    {\n"
    + "        glFragData0 = colorVarying;\n"
    + "}\n "

