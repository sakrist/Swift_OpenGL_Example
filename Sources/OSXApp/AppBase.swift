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
    
    public class AppBase: NSObject, NSApplicationDelegate, NSWindowDelegate, AppDelegate, MouseEventDelegate {
        var window: NSWindow!
        var glView: OpenGLView!
        public var renderObject: RenderObject? {
            didSet {
                glView.renderObject = self.renderObject
            }
        }
        
        public override init() {
            self.renderObject = nil
            
            let window = NSWindow(contentRect: NSMakeRect(0, 0, 640, 480), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask, backing: .Buffered, defer: false)
            window.center()
            window.title = "OpenGL Example Swift"
            self.window = window
        }
        
        public func applicationDidFinishLaunching(notification: NSNotification) {
            
            var rect = window.frame
            rect.origin.x = 0.0
            rect.origin.y = 0.0
            
            let glview = OpenGLView(frame:rect)
            glview.application = self
            glview.createGL()
            glview.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
            self.glView = glview;
            self.window?.contentView?.addSubview(glview)
            
            self.window.delegate = self
            self.window.makeKeyAndOrderFront(window)
            
            glview.becomeFirstResponder()
            
            self.applicationCreate()            
        }
        
        public func windowWillClose(notification: NSNotification) {
            self.applicationClose()
            NSApplication.sharedApplication().terminate(0)
        }
        
        public func windowDidResize(notification: NSNotification) {
            let rect = window.frame
            let frame = Rect(Double(rect.origin.x), Double(rect.origin.y), Double(rect.size.width), Double(rect.size.height))
            self.windowDidResize(frame)
        }
        
        public func run() {
            NSApplication.sharedApplication().run()
        }
        
        // base functions
        public func applicationCreate() {}
        public func applicationClose() {}
        
        public func needsDisplay() {
           glView.display()
        }
        
        public func windowDidResize(size:Rect) {}
        
        // MouseEventDelegate
        
        public func mouseDown(point:Point, button:Int) {}
        public func mouseMove(point:Point) {}
        public func mouseUp(point:Point) {}
        
    }
    
#endif

