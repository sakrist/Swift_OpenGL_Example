//
//  AppBase.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

#if os(OSX)
    import Darwin.C
    import Foundation
    import AppKit
    import Cocoa
    
    import utils
    
    open class AppBase: NSObject, NSApplicationDelegate, NSWindowDelegate, AppDelegate, MouseEventDelegate {
        var window: NSWindow!
        var glView: OpenGLView!
        public var renderObject: RenderObject? {
            didSet {
                glView.renderObject = self.renderObject
            }
        }
        
        public override init() {
            self.renderObject = nil
            
            let window = NSWindow(contentRect: NSMakeRect(0, 0, 640, 480), styleMask: [NSWindowStyleMask.titled, NSWindowStyleMask.closable, NSWindowStyleMask.miniaturizable, NSWindowStyleMask.resizable], backing: .buffered, defer: false)
            window.center()
            window.title = "OpenGL Example Swift"
            self.window = window
        }
        
        open func applicationDidFinishLaunching(_ aNotification: Notification) {
            
            var rect = window.frame
            rect.origin.x = 0.0
            rect.origin.y = 0.0
            
            let glview = OpenGLView(frame:rect)
            glview.application = self
            glview.createGL()
            glview.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            self.glView = glview;
            self.window?.contentView?.addSubview(glview)
            
            self.window.delegate = self
            self.window.makeKeyAndOrderFront(window)
            
            glview.becomeFirstResponder()
            
            self.applicationCreate()            
        }
        
        open func windowWillClose(_ notification: Notification) {
            self.applicationClose()
            NSApplication.shared().terminate(0)
        }
        
        open func windowDidResize(_ notification: Notification) {
            let rect = window.frame
            let frame = Rect(Double(rect.origin.x), Double(rect.origin.y), Double(rect.size.width), Double(rect.size.height))
            self.windowDidResize(size:frame)
        }
        
        open func run() {
            NSApplication.shared().run()
        }
        
        // base functions
        open func applicationCreate() {}
        open func applicationClose() {}
        
        open func needsDisplay() {
           glView.display()
        }
        
        open func windowDidResize(size:Rect) {}
        
        // MouseEventDelegate
        
        open func mouseDown(_ point:Point, button:Int) {}
        open func mouseMove(_ point:Point) {}
        open func mouseUp(_ point:Point) {}
        
    }
    
#endif

