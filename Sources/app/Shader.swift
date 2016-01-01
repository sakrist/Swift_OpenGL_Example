//
//  Shader.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 30/12/2015.
//
//

#if os(Linux)
    import Glibc
    import COpenGL.gl
#elseif os(OSX)
    import Darwin.C
    import GLKit
#endif


public let UNIFORM_MODELVIEWPROJECTION_MATRIX = 0
public let UNIFORM_NORMAL_MATRIX = 1


public class Shader {
    
    public static var positionAttribute:GLuint = 0
    public static var normalAttribute:GLuint = 1
    
    
    public var program:UInt32 = 0
    public var uniforms = [GLint](count: 2, repeatedValue: 0)
    
    public init?(vertexShader: String, fragmentShader: String) {
        
        var vertexShader_ = vertexShader;
        var fragmentShader_ = fragmentShader;
        
        let GL_version_cstring = glGetString(GLenum(GL_VERSION)) as UnsafePointer<UInt8>
        let GL_version_string = String.fromCString(GL_version_cstring)
        debugPrint(GL_version_string)
        
        let glsl_version_cstring = glGetString(GLenum(GL_SHADING_LANGUAGE_VERSION)) as UnsafePointer<UInt8>
        var glsl_version_string = String.fromCString(glsl_version_cstring)
        
        glsl_version_string.removeAtIndex(glsl_version_string.startIndex.advancedBy(1)) // delete point 1.30 -> 130
        glsl_version_string = "#version " + glsl_version_string
        
        var range = vertexShader_.rangesOfString("#version 000")
        vertexShader_.replaceRange(range[0], with: glsl_version_string)
        
        range = fragmentShader_.rangesOfString("#version 000")
        fragmentShader_.replaceRange(range[0], with: glsl_version_string)
        
        
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        
        // Create shader program.
        program = glCreateProgram()
                
        // Create and compile vertex shader.
        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), shaderString: vertexShader_) == false {
            print("Failed to compile vertex shader")
            return nil
        }
        
        // Create and compile fragment shader.
        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), shaderString: fragmentShader_) {
            print("Failed to compile fragment shader")
            return nil
        }
        
        // Attach vertex shader to program.
        glAttachShader(self.program, vertShader)
        
        // Attach fragment shader to program.
        glAttachShader(self.program, fragShader)
        
        // Bind attribute locations.
        // This needs to be done prior to linking.
        glBindAttribLocation(self.program, Shader.positionAttribute, "position")
        glBindAttribLocation(self.program, Shader.normalAttribute, "normal")
        
        
        glBindFragDataLocation(self.program, 0, "glFragData0");
        
        // Link program.
        if !self.linkProgram(self.program) {
            print("Failed to link program: \(self.program)")
            
            if vertShader != 0 {
                glDeleteShader(vertShader)
                vertShader = 0
            }
            if fragShader != 0 {
                glDeleteShader(fragShader)
                fragShader = 0
            }
            if program != 0 {
                glDeleteProgram(self.program)
                self.program = 0
            }
            
            return nil
        }
        
        // Get uniform locations.
        self.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix")
        self.uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(program, "normalMatrix")
        
        // Release vertex and fragment shaders.
        if vertShader != 0 {
            glDetachShader(program, vertShader)
            glDeleteShader(vertShader)
        }
        if fragShader != 0 {
            glDetachShader(program, fragShader)
            glDeleteShader(fragShader)
        }
        
//        self.validateProgram(program)
    }
    
    func compileShader(inout shader: GLuint, type: GLenum, shaderString: String) -> Bool {
        var status: GLint = 0
        
        let source = UnsafeMutablePointer<Int8>.alloc(shaderString.characters.count)
        let size = shaderString.characters.count
        var idx = 0
        for u in shaderString.utf8 {
            if idx == size - 1 { break }
            source[idx] = Int8(u)
            idx += 1
        }
        source[idx] = 0 // NUL-terminate the C string in the array.
        
        var castSource = UnsafePointer<GLchar>(source)
        
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        source.dealloc(shaderString.characters.count)
        
//        #if defined(DEBUG)
                var logLength: GLint = 0
                glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
                if logLength > 0 {
                    let log = UnsafeMutablePointer<GLchar>(malloc(Int(logLength))) as UnsafeMutablePointer<Int8>
                    glGetShaderInfoLog(shader, logLength, &logLength, log)

                    let logString = String.fromCString(log)
                    print(logString)
                    free(log)
                }
//        #endif
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return false
        }
        return true
    }
    
    func linkProgram(prog: GLuint) -> Bool {
        var status: GLint = 0
        glLinkProgram(prog)
        
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            return false
        }
        
        return true
    }
    
    func validateProgram(prog: GLuint) -> Bool {
        var logLength: GLsizei = 0
        var status: GLint = 0
        
        glValidateProgram(prog)
        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log: [GLchar] = [GLchar](count: Int(logLength), repeatedValue: 0)
            glGetProgramInfoLog(prog, logLength, &logLength, &log)
            print("Program validate log: \n\(String.fromCString(log))")
        }
        
        glGetProgramiv(prog, GLenum(GL_VALIDATE_STATUS), &status)
        var returnVal = true
        if status == 0 {
            returnVal = false
        }
        return returnVal
    }
    
    func use() {
        glUseProgram(self.program)
    }
    
}