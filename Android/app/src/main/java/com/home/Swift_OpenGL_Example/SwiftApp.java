package com.home.Swift_OpenGL_Example;

public class SwiftApp {

    static {
        System.loadLibrary("AppBase");
        System.loadLibrary("app");
    }

    public native int applicationCreate();
}
