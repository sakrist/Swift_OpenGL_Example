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
    import COpenGL.glx
#elseif os(OSX)
    import Darwin.C
    import Cocoa
#endif


import utils

func BUFFER_OFFSET(i: Int) -> UnsafePointer<Void> {
    let p: UnsafePointer<Void> = nil
    return p.advancedBy(i)
}


public class Scene: RenderObject {
    
    var shader:Shader!
    
    var geometries:[Geometry] = []
    
    var modelViewProjectionMatrix = float4x4()
    var normalMatrix = float3x3()
    var rotation: Float = 0.5
    
    var size:Size = Size(width:640, height:480)
    
    init() {
        
        // init shader
        self.shader = Shader(vertexShader:vertexShader, fragmentShader:fragmentShader)
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
    }
    
    func update() {
        let aspect = fabsf(Float(size.width / size.height))
        let projectionMatrix = perspective((65.0 * (3.14 / 180.0)), aspect:aspect, nearZ:0.1, farZ:100.0)
        
        var baseModelViewMatrix = float4x4(matrix_identity_float4x4)
        baseModelViewMatrix[3][2] = -4.0
        baseModelViewMatrix = baseModelViewMatrix * rotate(rotation, x:0.0, y:1.0, z:0.0)
        
        var modelViewMatrix = float4x4(matrix_identity_float4x4)
        modelViewMatrix = modelViewMatrix * rotate(rotation, x:1.0, y:1.0, z:1.0)
        modelViewMatrix = baseModelViewMatrix * modelViewMatrix
        
        modelViewProjectionMatrix = projectionMatrix * modelViewMatrix
        
        normalMatrix = float4x4to3x3(true, M:modelViewMatrix)
        
    }
    
    public func render() {
    
        self.update()
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glClearColor(0.65, 0.65, 0.65, 1.0)
        
        // Use shader
        self.shader.use()
        
        withUnsafePointer(&modelViewProjectionMatrix, {
            glUniformMatrix4fv(self.shader.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, UnsafePointer($0))
        })
        
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(self.shader.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, UnsafePointer($0))
        })
        
        // Draw objects        
        for g in geometries {
            g.draw()
        }
    }
}


var vertexShader = "#version 000  \n "
+ "in vec4 position;\n"
+ "in vec3 normal;\n"
+ "\n"
+ "out vec4 colorVarying;\n"
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
+ "in vec4 colorVarying;\n"
+ "\n"
+ "out vec4 glFragData0;\n"
+ "void main()\n"
+ "    {\n"
+ "        glFragData0 = colorVarying;\n"
+ "}\n "


