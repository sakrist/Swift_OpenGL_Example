//
//  GLView.swift
//  iOSApp
//
//  Created by Volodymyr Boichentsov on 30/12/2017.
//

#if os(iOS)
import Foundation
import UIKit
import GLKit

open class GLView : GLKView {
    
    var application:AppBase?
    var _context:EAGLContext?
    
    override init(frame: CGRect) {
        _context = EAGLContext.init(api: EAGLRenderingAPI.openGLES3)
        EAGLContext.setCurrent(_context)
        super.init(frame: frame, context: _context! )
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            application?.mouseDown(Point(Double(location.x), Double(location.y)), button: 0)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            application?.mouseMove(Point(Double(location.x), Double(location.y)))
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            application?.mouseUp(Point(Double(location.x), Double(location.y)))
        }
    }
} 

#endif
