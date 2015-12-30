//
//  AppDelegate.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 29/12/2015.
//
//

public protocol AppDelegate {
    var renderObject: RenderObject! { get set }
    func applicationCreate()
    func applicationClose()
    func run()
}
