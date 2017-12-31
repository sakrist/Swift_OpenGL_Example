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
    
open class AppBase: AppDelegate, MouseEventDelegate {
    
    open var renderObject: RenderObject?
    
    var display:UnsafeMutablePointer<Display>!
    var screen:UnsafeMutablePointer<Screen>!
    var rootWindow:Window!
    
    var window:Window!
    
    var visInfo:UnsafeMutablePointer<XVisualInfo>!
    var glContext:GLXContext!
    
    var frame:Rect = Rect(0.0, 0.0, 640, 480)

    var buttonDownFlag:Int = 0

    public init() {

        self.display = XOpenDisplay(nil)
        self.screen = XDefaultScreenOfDisplay(display)
        self.rootWindow = screen.pointee.root

        let att = UnsafeMutablePointer<Int32>.allocate(capacity:5)
        att[0] = GLX_RGBA
        att[1] = GLX_DEPTH_SIZE
        att[2] = 24
        att[3] = GLX_DOUBLEBUFFER
        att[4] = 0

        self.visInfo = glXChooseVisual(display, 0, att)

        att.deallocate(capacity:5)

        if(visInfo == nil) {
            print("No appropriate visual found")
            exit(0)
        }
        else {
            print("visual \(visInfo.pointee.visualid)")
        }

        // create window
        let cmap = XCreateColormap(display, rootWindow, visInfo.pointee.visual, AllocNone)
        var swa:XSetWindowAttributes = XSetWindowAttributes()
        swa.colormap = cmap
        swa.event_mask = ExposureMask | KeyPressMask | PointerMotionMask | ButtonPressMask | ButtonReleaseMask

        self.window = XCreateWindow(display, rootWindow,
            Int32(frame.origin.x), Int32(frame.origin.y),
            UInt32(frame.size.width), UInt32(frame.size.height), 0, visInfo.pointee.depth,
            UInt32(InputOutput), visInfo.pointee.visual,
            UInt(CWColormap) | UInt(CWEventMask), &swa)

        XMapWindow(display, window)
        XStoreName(display, window, "OpenGL Example Swift")

        // create gl context
        glContext = glXCreateContext(display, visInfo, nil, GL_TRUE)
        glXMakeCurrent(display, window, glContext)

        self.applicationCreate()
    }



    // AppDelegate functions

    open func run() {

        let event = UnsafeMutablePointer<_XEvent>.allocate(capacity:1)
        let gwa = UnsafeMutablePointer<XWindowAttributes>.allocate(capacity:1)

        loop: while true {
            // Wait for the next event
            XNextEvent(display, event)

            switch event.pointee.type {

                // The window has to be drawn
            case Expose:
                XGetWindowAttributes(display, window, gwa)
                let width = Double(gwa.pointee.width)
                let height = Double(gwa.pointee.height)
                if frame.size.width != width || frame.size.height != height {
                    frame.size = Size(width, height)
                    self.windowDidResize(frame.size)
                    glViewport(0, 0, gwa.pointee.width, gwa.pointee.height)
                }

                self.needsDisplay()

                break

            case MotionNotify:
                if buttonDownFlag != 0 {
                    mouseMove(Point(Double(event.pointee.xmotion.x), Double(event.pointee.xmotion.y)))
                }

                break
            case ButtonPress:
                mouseDown(Point(Double(event.pointee.xbutton.x), Double(event.pointee.xbutton.y)), button:Int(event.pointee.xbutton.button))
                buttonDownFlag |= Int(event.pointee.xbutton.button)
                break
            case ButtonRelease:
                mouseUp(Point(Double(event.pointee.xbutton.x), Double(event.pointee.xbutton.y)))
                buttonDownFlag = buttonDownFlag ^ Int(event.pointee.xbutton.button)
                break

                // The user did press
            case KeyPress:

                // close app by cntrl+q
                if((event.pointee.xkey.keycode == 24 && event.pointee.xkey.state == 4))
                {
                    glXMakeCurrent(display, 0, nil)
                    glXDestroyContext(display, glContext)
                    XDestroyWindow(display, window)
                    XCloseDisplay(display)
                    break loop
                }

                // We never signed up for this event
            default: print("\(event.pointee)")

            }
        }

        self.applicationClose()

        event.deallocate(capacity:1)
        gwa.deallocate(capacity:1)

        exit(0)
    }

    open func applicationCreate() {}
    open func applicationClose() {}

    open func needsDisplay() {
        glXMakeCurrent(display, window, glContext)
        if renderObject != nil {
            renderObject?.render()
        }
        glXSwapBuffers(display, window)
    }

    open func windowDidResize(_ size:Size) {}


    // MouseEventDelegate

    open func mouseDown(_ point:Point, button:Int) {}
    open func mouseMove(_ point:Point) {}
    open func mouseUp(_ point:Point) {}

}

#endif
