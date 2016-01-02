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


public class Scene: RenderObject {
    
    var shader:Shader!
    
    var geometries:[Geometry] = []
    
    var modelViewProjectionMatrix = matrix_identity_float4x4
    var modelViewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
    
    var normalMatrix = float3x3()
    
    var fovAngle:Float = 65.0
    var farZ:Float = 100.0
    var nearZ:Float = 0.1
    
    var size:Size = Size(640, 480) {
        didSet {
            let aspect = fabsf(Float(size.width / size.height))
            projectionMatrix = perspective( degreesToRadians(fovAngle), aspect:aspect, nearZ:nearZ, farZ:farZ)
        }
    }
    
    init() {
        
        // init shader
        self.shader = Shader(vertexShader:vertexShader, fragmentShader:fragmentShader)
        
        glEnable(GLenum(GL_DEPTH_TEST))
                
        modelViewMatrix = translate(x:0, y:0, z:-4.0)
        
        update()
    }
    
    func update() {
        
        modelViewProjectionMatrix = projectionMatrix * modelViewMatrix
        
        normalMatrix = float4x4to3x3(transpose:false, modelViewMatrix)
        var invertible = true
        normalMatrix = invert(normalMatrix, isInvertible:&invertible)
        normalMatrix = transpose(normalMatrix)
        
    }
    
    public func render() {
    
        update()
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glClearColor(0.65, 0.65, 0.65, 1.0)
        
        // Use shader
        shader.use()
        
        withUnsafePointer(&modelViewProjectionMatrix, {
            glUniformMatrix4fv(shader.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, UnsafePointer($0))
        })
        
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(shader.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, UnsafePointer($0))
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


