//
//  Types.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

struct Point {
    var x:Double = 0
    var y:Double = 0
}

struct Size {
    var width:Double = 0
    var height:Double = 0
}

struct Rect {
    var origin = Point(x:0.0, y:0.0)
    var size = Size(width:0.0, height:0.0)
}