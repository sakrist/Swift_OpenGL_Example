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
#elseif os(iOS)
    import OpenGLES
    import OpenGLES.ES3
#endif

public func isGLOn() -> Bool {
    let v = glGetString(GLenum(GL_VERSION))
    if (v != nil) {
        return true
    }
    return false
} 


public let UNIFORM_MODELVIEWPROJECTION_MATRIX = 0
public let UNIFORM_NORMAL_MATRIX = 1

public class Shader {
    
    public static var positionAttribute:GLuint = 0
    public static var normalAttribute:GLuint = 1
    
    
    public var program:UInt32 = 0
    public var uniforms = [GLint](repeating: 0, count: 2)
    
    public init?(vertexShader: String, fragmentShader: String) {
        
        var vertexShader_ = vertexShader;
        var fragmentShader_ = fragmentShader;
        
        let GL_version_cstring = glGetString(GLenum(GL_VERSION)) as UnsafePointer<UInt8>
        let GL_version_string = String(cString:GL_version_cstring)
        debugPrint(GL_version_string)
        
        let glsl_version_cstring = glGetString(GLenum(GL_SHADING_LANGUAGE_VERSION)) as UnsafePointer<UInt8>
        var glsl_version_string = String(cString:glsl_version_cstring)
        
        // test if it's ES
        let isES = glsl_version_string.contains("ES")
        
        if let lastString = glsl_version_string.split(separator: " ").last {
            glsl_version_string = String.init(lastString)
        }
        glsl_version_string.remove(at:glsl_version_string.index(glsl_version_string.startIndex, offsetBy: 1)) // delete point 1.30 -> 130
        
        // get version into Int value
        let glslVersion = Int(glsl_version_string) ?? 0
        
        // form string for replacement
        glsl_version_string = "version " + glsl_version_string + ((isES && glslVersion > 100) ? " es" : "" ) 
        
        // replace version
        var range = vertexShader_.rangesOfString("version 000")
        for r in range {
            vertexShader_.replaceSubrange(r, with: glsl_version_string)
        }
        
        range = fragmentShader_.rangesOfString("version 000")
        for r in range {
            fragmentShader_.replaceSubrange(r, with: glsl_version_string)
        }
        
        // create macro for version
        let glslVersionMacro = "version \(glslVersion)"
        
        // create macorses string
        let macroses = "#define " + glslVersionMacro + "\n"
        
        // set macroses
        range = vertexShader_.rangesOfString("// macroses")
        for r in range {
            vertexShader_.replaceSubrange(r, with: macroses)
        }
        
        range = fragmentShader_.rangesOfString("// macroses")
        for r in range {
            fragmentShader_.replaceSubrange(r, with: macroses)
        }
        
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        
        // Create shader program.
        program = glCreateProgram()
        
        // Create and compile vertex shader.
        if self.compileShader(shader: &vertShader, type: GLenum(GL_VERTEX_SHADER), shaderString: vertexShader_) == false {
            print("Failed to compile vertex shader")
            print(vertexShader_)
            return nil
        }
        
        // Create and compile fragment shader.
        if !self.compileShader(shader: &fragShader, type: GLenum(GL_FRAGMENT_SHADER), shaderString: fragmentShader_) {
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
        
        #if os(iOS)
            glGetFragDataLocation(self.program, "glFragData0");
        #else
            glBindFragDataLocation(self.program, 0, "glFragData0");
        #endif
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
    
    func compileShader(shader: inout GLuint, type: GLenum, shaderString: String) -> Bool {
        var status: GLint = 0
        
        let source = UnsafeMutablePointer<Int8>.allocate(capacity: shaderString.count)
        let size = shaderString.count
        var idx = 0
        for u in shaderString.utf8 {
            if idx == size - 1 { break }
            source[idx] = Int8(u)
            idx += 1
        }
        source[idx] = 0 // NUL-terminate the C string in the array.

        var castSource: UnsafePointer<GLchar>? = UnsafePointer<GLchar>(source)

        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        source.deallocate(capacity: shaderString.count)
        
//        #if defined(DEBUG)
        var logLength: GLint = 0
        glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log = [GLchar](repeating: 0, count: 512)
            glGetShaderInfoLog(shader, 512, &logLength, &log)
            
            let logString = String(cString:log)
            print(logString)
            
        }
//        #endif

        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return false
        }
        return true
    }
    
    func linkProgram(_ prog: GLuint) -> Bool {
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
            var log: [GLchar] = [GLchar](repeating: 0, count: Int(logLength))
            glGetProgramInfoLog(prog, logLength, &logLength, &log)
            print("Program validate log: \n\(String(cString:log))")
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
