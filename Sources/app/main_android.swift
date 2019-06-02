//
//  main_android.swift
//  Swift_OpenGL_Example
//
//  Created by Volodymyr Boichentsov on 01/06/2019.
//
//

#if os(Android)
import Foundation
import AppBase

var app:App?

@_cdecl("Java_com_home_Swift_1OpenGL_1Example_SwiftApp_applicationCreate")
public func applicationCreate() {
    app = App()
    app!.applicationCreate()
}
#endif
