//
//  Types.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

public struct Point {
    public var x:Double = 0
    public var y:Double = 0
    public init(x:Double, y:Double) {
        self.x = x
        self.y = y
    }
}

public struct Size {
    public var width:Double = 0
    public var height:Double = 0

    public init(width:Double, height:Double) {
        self.width = width
        self.height = height
    }
}

public struct Rect {
    public var origin = Point(x:0.0, y:0.0)
    public var size = Size(width:0.0, height:0.0)
    public init(origin:Point, size:Size) {
        self.origin = origin
        self.size = size
    }
}