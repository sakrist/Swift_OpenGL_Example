//
//  AppBase.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

#if os(iOS)
import Darwin.C
import Foundation
import UIKit
import GLKit

open class AppBase: UIResponder, UIApplicationDelegate, AppDelegate, GLKViewDelegate, MouseEventDelegate {
    
    public var window: UIWindow?
    public var glview: GLView?
    public var renderObject: RenderObject?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        
        // Configure GLView. Our gl view is subclass of GLKView
        self.glview = GLView.init(frame: frame)
        self.glview?.drawableDepthFormat = GLKViewDrawableDepthFormat.format24
        self.glview?.delegate = self;
        self.glview?.application = self;
        self.applicationCreate()
        self.windowDidResize(Size(Double(frame.size.width), Double(frame.size.height)))
        
        let initialViewController = UIViewController()
        window?.rootViewController = initialViewController
        initialViewController.view = self.glview
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        
    }
    public func applicationWillTerminate(_ application: UIApplication) {
        self.applicationClose()
    }
    
    open func run() {
        // not required for iOS
    }
    
    // base functions
    open func applicationCreate() {}
    open func applicationClose() {}
    
    open func needsDisplay() {
        self.glview?.setNeedsDisplay();
    }
    
    public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        if renderObject != nil {
            renderObject?.render()
        }
    }
    
    open func windowDidResize(_ size:Size) {}
    
    // MouseEventDelegate
    
    open func mouseDown(_ point:Point, button:Int) {}
    open func mouseMove(_ point:Point) {}
    open func mouseUp(_ point:Point) {}
    
}
    
#endif

