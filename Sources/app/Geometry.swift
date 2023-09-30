//
//  Geometry.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 01/01/2016.
//
//

#if os(Linux)
import Glibc
import OpenGL
#elseif os(OSX)
import Darwin.C
import Cocoa
import OpenGL
#elseif os(iOS)
import OpenGLES
#elseif os(Android)
import Glibc
import ndk.GLES3
#elseif os(Windows)
import Win.GL
#endif

func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer? {
    let off = UnsafeRawPointer(bitPattern: i)
    return off
}

class Geometry {
    
    var vertexArray: GLuint = 0
    var vertexBuffer: GLuint = 0
    
    var dataCount:Int32 = 0
    var indicesCount:Int32 = 0
    
    init(data:[Float32]) {
    
        dataCount = Int32(data.count)
        indicesCount = dataCount/6
        
        glGenVertexArrays(1, &vertexArray)
        glBindVertexArray(vertexArray)
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<Float32>.size * Int(dataCount)), data, GLenum(GL_STATIC_DRAW))

        glEnableVertexAttribArray(Shader.positionAttribute)
        glVertexAttribPointer(Shader.positionAttribute, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(0))
        glEnableVertexAttribArray(Shader.normalAttribute)
        glVertexAttribPointer(Shader.normalAttribute, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(12))
        
        glBindVertexArray(0)
    
    }
    
    
    func draw() {
        glBindVertexArray(vertexArray)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, indicesCount)
    }
    
}
