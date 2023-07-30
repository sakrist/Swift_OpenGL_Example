package com.home.Swift_OpenGL_Example;

public class SwiftApp {

    static {
        System.loadLibrary("icudata");
        System.loadLibrary("icuuc");
        System.loadLibrary("icui18n");
        System.loadLibrary("Foundation");
        System.loadLibrary("dispatch");
        System.loadLibrary("OpenGLExampleApp");
    }

    public native int applicationCreate();
    public native void needsDisplay();
    public native void windowDidResize(int width, int height);

    public native void pointerDown(int x, int y);
    public native void pointerMove(int x, int y);
    public native void pointerUp(int x, int y);
}
