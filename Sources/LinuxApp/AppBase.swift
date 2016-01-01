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
    
import utils

public class AppBase: AppDelegate, MouseEventDelegate {
    
    public var renderObject: RenderObject?
    
    var display:UnsafeMutablePointer<Display>!
    var screen:UnsafeMutablePointer<Screen>!
    var rootWindow:Window!
    
    var window:Window!
    
    var visInfo:UnsafeMutablePointer<XVisualInfo>!
    var glContext:GLXContext!
    
    var frame:Rect = Rect(origin:Point(x:0.0, y:0.0) ,size:Size(width:640, height:480))
    
    var buttonDownFlag:Int = 0
    
    public init() {
    
        self.display = XOpenDisplay(nil)
        self.screen = XDefaultScreenOfDisplay(display)
        self.rootWindow = screen.memory.root
        
        let att = UnsafeMutablePointer<Int32>.alloc(5)
        att[0] = GLX_RGBA
        att[1] = GLX_DEPTH_SIZE
        att[2] = 24
        att[3] = GLX_DOUBLEBUFFER
        att[4] = 0
        
        self.visInfo = glXChooseVisual(display, 0, att)
        
        att.dealloc(5)
        
        if(visInfo == nil) {
            print("No appropriate visual found")
            exit(0)
        }
        else {
            print("visual \(visInfo.memory.visualid)")
        }        
        
        // create window
        let cmap = XCreateColormap(display, rootWindow, visInfo.memory.visual, AllocNone)
        var swa:XSetWindowAttributes = XSetWindowAttributes()
        swa.colormap = cmap
        swa.event_mask = ExposureMask | KeyPressMask | PointerMotionMask | ButtonPressMask | ButtonReleaseMask
        
        self.window = XCreateWindow(display, rootWindow,
            Int32(frame.origin.x), Int32(frame.origin.y),
            UInt32(frame.size.width), UInt32(frame.size.height), 0, visInfo.memory.depth,
            UInt32(InputOutput), visInfo.memory.visual,
            UInt(CWColormap) | UInt(CWEventMask), &swa)
        
        XMapWindow(display, window)
        XStoreName(display, window, "OpenGL Example Swift")
    
        // create gl context
        glContext = glXCreateContext(display, visInfo, nil, GL_TRUE)
        glXMakeCurrent(display, window, glContext)

        self.applicationCreate()
    }
    
    
    
    // AppDelegate functions
    
    public func run() {
        
        let event = UnsafeMutablePointer<_XEvent>.alloc(1)
        let gwa = UnsafeMutablePointer<XWindowAttributes>.alloc(1)
        
        loop: while true {
            // Wait for the next event
            XNextEvent(display, event)
            
            switch event.memory.type {
            
                // The window has to be drawn
            case Expose:
                XGetWindowAttributes(display, window, gwa)
                let width = Double(gwa.memory.width)
                let height = Double(gwa.memory.height)
                if frame.size.width != width || frame.size.height != height {
                    frame.size = Size(width:width, height:height)
                    self.windowDidResize(frame)
                    glViewport(0, 0, gwa.memory.width, gwa.memory.height)
                }

                self.needsDisplay()
                
                break
                
            case MotionNotify:
                if buttonDownFlag != 0 {
                    mouseMove(Point(x:Double(event.memory.xmotion.x),y:Double(event.memory.xmotion.y)))
                }
                
                break
            case ButtonPress:
                mouseDown(Point(x:Double(event.memory.xbutton.x),y:Double(event.memory.xbutton.y)), button:Int(event.memory.xbutton.button))
                buttonDownFlag |= Int(event.memory.xbutton.button)
                break
            case ButtonRelease:
                mouseUp(Point(x:Double(event.memory.xbutton.x),y:Double(event.memory.xbutton.y)))
                buttonDownFlag = buttonDownFlag ^ Int(event.memory.xbutton.button)
                break
                
                // The user did press
            case KeyPress:
                
                // close app by cntrl+q
                if((event.memory.xkey.keycode == 24 && event.memory.xkey.state == 4))
                {
                    glXMakeCurrent(display, 0, nil)
                    glXDestroyContext(display, glContext)
                    XDestroyWindow(display, window)
                    XCloseDisplay(display)
                    break loop
                }
                
                // We never signed up for this event
            default: print("\(event.memory)")
                
            }
        }
        
        self.applicationClose()
        
        event.dealloc(1)
        gwa.dealloc(1)

        exit(0)
    }
    
    public func applicationCreate() {}
    public func applicationClose() {}

    public func needsDisplay() {
        glXMakeCurrent(display, window, glContext)
        if renderObject != nil {
            renderObject?.render()
        }
        glXSwapBuffers(display, window)
    }
    
    public func windowDidResize(frame:Rect) {}
    
    
    // MouseEventDelegate
    
    public func mouseDown(point:Point, button:Int) {}
    public func mouseMove(point:Point) {}
    public func mouseUp(point:Point) {}
    
}
    
#endif
