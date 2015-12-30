//
//  AppBase.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//


#if os(Linux)
import Glibc
import CX11.X
import CX11.Xlib
    
import COpenGL.gl
import COpenGL.glx
    
import core

public class AppBase: AppDelegate {
    
    public var renderObject: RenderObject!
    
    var display:_XPrivDisplay!
    var screen:UnsafeMutablePointer<Screen>!
    var rootWindow:Window!
    
    var window:Window!
    
    var visInfo:UnsafeMutablePointer<XVisualInfo>!
    var glContext:GLXContext!
    
    
    public init() {
    
        self.display = XOpenDisplay(nil)
        self.screen = XDefaultScreenOfDisplay(self.display)
        self.rootWindow = self.screen.memory.root
        
        
        let att = UnsafeMutablePointer<Int32>.alloc(5)
        att[0] = GLX_RGBA
        att[1] = GLX_DEPTH_SIZE
        att[2] = 24
        att[3] = GLX_DOUBLEBUFFER
        att[4] = 0
        
        self.visInfo = glXChooseVisual(self.display, 0, att)
        
        att.dealloc(5)
        
        if(visInfo == nil) {
            print("No appropriate visual found")
            exit(0)
        }
        else {
            print("visual \(visInfo.memory.visualid)")
        }
        
        let cmap = XCreateColormap(self.display, self.rootWindow, self.visInfo.memory.visual, AllocNone);
        var swa:XSetWindowAttributes = XSetWindowAttributes()
        swa.colormap = cmap;
        swa.event_mask = ExposureMask | KeyPressMask;
        
        self.window = XCreateWindow(self.display, self.rootWindow,
            0, 0, 600, 600, 0, self.visInfo.memory.depth,
            UInt32(InputOutput), self.visInfo.memory.visual,
            UInt(CWColormap) | UInt(CWEventMask), &swa);
        
        XMapWindow(self.display, self.window);
        XStoreName(self.display, self.window, "OpenGL Example Swift");
        
        glContext = glXCreateContext(self.display, self.visInfo, nil, GL_TRUE);
        glXMakeCurrent(self.display, self.window, glContext);

        self.applicationCreate()
    }
    
    
    public func run() {
        
        let event = UnsafeMutablePointer<_XEvent>.alloc(1)
        let gwa = UnsafeMutablePointer<XWindowAttributes>.alloc(1)
        
        loop: while true {
            // Wait for the next event
            XNextEvent(self.display, event)
            
            switch event.memory.type {
                // The window has to be drawn
            case Expose:
                XGetWindowAttributes(self.display, self.window, gwa)
                glViewport(0, 0, gwa.memory.width, gwa.memory.height)
                if self.renderObject != nil {
                    self.renderObject.render()
                }
                glXSwapBuffers(self.display, self.window)
                break
                
                // The user did press
            case KeyPress:
                glXMakeCurrent(self.display, 0, nil)
                glXDestroyContext(self.display, self.glContext)
                XDestroyWindow(self.display, self.window)
                XCloseDisplay(self.display)
                break loop
                
                // We never signed up for this event
            default: print("\(event.memory.type)")
                
            }
        }
        
        self.applicationClose()
        
        event.dealloc(1)
        gwa.dealloc(1)

        exit(0)
    }
    
    // base functions
    public func applicationCreate() {}
    public func applicationClose() {}
}
    
#endif
