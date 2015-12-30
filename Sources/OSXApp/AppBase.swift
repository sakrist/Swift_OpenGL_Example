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
    
    import core
    
    public class AppBase: NSObject, NSApplicationDelegate, NSWindowDelegate, AppDelegate {
        var window: NSWindow!
        var glView: OpenGLView!
        public var renderObject: RenderObject!
        
        public override init() {
            let window = NSWindow(contentRect: NSMakeRect(0, 0, 640, 480), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask, backing: .Buffered, defer: false)
            window.center()
            window.title = "OpenGLView"
            self.window = window
        }
        
        public func applicationDidFinishLaunching(notification: NSNotification) {
            
            self.applicationCreate()
            
            var rect = self.window.frame
            rect.origin.x = 0.0
            rect.origin.y = 0.0
            
            let glview = OpenGLView(frame:rect)
            glview.createGL()
            glview.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
            self.glView = glview;
            self.glView.renderObject = self.renderObject;
            self.window?.contentView?.addSubview(glview)
            
            
            self.window.delegate = self
            self.window.makeKeyAndOrderFront(self.window)
            
            glview.becomeFirstResponder()
        }
        
        public func windowWillClose(notification: NSNotification) {
            self.applicationClose()
            NSApplication.sharedApplication().terminate(0)
        }
        
        public func run() {
            NSApplication.sharedApplication().run()
        }
        
        // base functions
        public func applicationCreate() {}
        public func applicationClose() {}
    }
    
#endif

