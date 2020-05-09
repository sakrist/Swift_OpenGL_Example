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

open class AppBase: NSObject, NSApplicationDelegate, NSWindowDelegate, AppDelegate, MouseEventDelegate {
    var window: NSWindow!
    var glView: OpenGLView!
    public var renderObject: RenderObject? {
        didSet {
            glView.renderObject = self.renderObject
        }
    }
    
    func makeMainMenu() -> NSMenu {
        let mainMenu            = NSMenu() // `title` really doesn't matter.
        let mainAppMenuItem     = NSMenuItem(title: "Application", action: nil, keyEquivalent: "") // `title` really doesn't matter.
        mainMenu.addItem(mainAppMenuItem)

        let appMenu             = NSMenu() // `title` really doesn't matter.
        mainAppMenuItem.submenu = appMenu

        let appServicesMenu     = NSMenu()
        NSApp.servicesMenu      = appServicesMenu

        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Hide Me", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        appMenu.addItem({ () -> NSMenuItem in
            let m = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
            m.keyEquivalentModifierMask = [.command, .option]
            return m
            }())
        appMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")

        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

    
        return mainMenu
    }
    
    public override init() {
        super.init()
        self.renderObject = nil
        
        let window = NSWindow(contentRect: NSMakeRect(0, 0, 640, 480), styleMask: [NSWindow.StyleMask.titled, NSWindow.StyleMask.closable, NSWindow.StyleMask.miniaturizable, NSWindow.StyleMask.resizable], backing: .buffered, defer: false)
        window.center()
        window.title = "OpenGL Example Swift"
        self.window = window
        
        let application = NSApplication.shared
        application.setActivationPolicy(NSApplication.ActivationPolicy.regular)
        application.delegate = self
        application.activate(ignoringOtherApps:true)
        NSApplication.shared.mainMenu = makeMainMenu()
    }
    
    open func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        var rect = window.frame
        rect.origin.x = 0.0
        rect.origin.y = 0.0
        
        let glview = OpenGLView(frame:rect)
        glview.application = self
        glview.createGL()
        glview.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
        self.glView = glview;
        self.window?.contentView?.addSubview(glview)
        
        self.window.delegate = self
        self.window.makeKeyAndOrderFront(window)
        
        glview.becomeFirstResponder()
        
        self.applicationCreate()
    }
    
    open func windowWillClose(_ notification: Notification) {
        self.applicationClose()
        NSApplication.shared.terminate(0)
    }
    
    open func windowDidResize(_ notification: Notification) {
        let size = Size(Double(window.frame.size.width), Double(window.frame.size.height))
        self.windowDidResize(size)
    }
    
    open func run() {
        NSApplication.shared.run()
    }
    
    // base functions
    open func applicationCreate() {}
    open func applicationClose() {}
    
    open func needsDisplay() {
       glView.display()
    }
    
    open func windowDidResize(_ size:Size) {}
    
    // MouseEventDelegate
    
    open func mouseDown(_ point:Point, button:Int) {}
    open func mouseMove(_ point:Point) {}
    open func mouseUp(_ point:Point) {}
    
}
    
#endif

