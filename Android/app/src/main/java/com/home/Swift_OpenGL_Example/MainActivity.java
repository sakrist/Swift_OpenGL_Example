package com.home.Swift_OpenGL_Example;

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.RelativeLayout;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

public class MainActivity extends Activity {

    SwiftApp swiftApp;
    GLView mView;

    @Override protected void onCreate(Bundle icicle) {
        super.onCreate(icicle);

        if (swiftApp == null) {
            swiftApp = new SwiftApp();
        }

        mView = new GLView(getApplication());

        Renderer render = new MainActivity.Renderer();
        render.swiftApp = swiftApp;
        /* Set the renderer responsible for frame rendering */
        mView.setRenderer(render);

        setContentView(mView);

        TouchListener listener = new TouchListener();
        listener.swiftApp = swiftApp;
        mView.setOnTouchListener(listener);
    }

    @Override protected void onPause() {
        super.onPause();
        mView.onPause();
    }

    @Override protected void onResume() {
        super.onResume();
        mView.onResume();
    }

    private static class Renderer implements GLSurfaceView.Renderer {
        public SwiftApp swiftApp;

        public void onDrawFrame(GL10 gl) {
            swiftApp.needsDisplay();
        }

        public void onSurfaceChanged(GL10 gl, int width, int height) {
            swiftApp.windowDidResize(width, height);
        }

        public void onSurfaceCreated(GL10 gl, EGLConfig config) {

            int result = swiftApp.applicationCreate();
            Log.i("Swift", "applicationCreate " + result);
        }
    }

    private static class TouchListener implements View.OnTouchListener{
        public SwiftApp swiftApp;

        public boolean onTouch(View view, MotionEvent event) {
            final int X = (int) event.getRawX();
            final int Y = (int) event.getRawY();
            switch (event.getAction() & MotionEvent.ACTION_MASK) {
                case MotionEvent.ACTION_DOWN:
                    swiftApp.pointerDown(X, Y);
                    break;
                case MotionEvent.ACTION_UP:
                    swiftApp.pointerUp(X, Y);
                    break;
                case MotionEvent.ACTION_POINTER_DOWN:
                    swiftApp.pointerDown(X, Y);
                    break;
                case MotionEvent.ACTION_POINTER_UP:
                    swiftApp.pointerUp(X, Y);
                    break;
                case MotionEvent.ACTION_MOVE:
                    swiftApp.pointerMove(X, Y);
                    break;
            }
            return true;
        }
    }

}
