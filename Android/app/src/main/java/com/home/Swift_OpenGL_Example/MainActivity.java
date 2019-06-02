package com.home.Swift_OpenGL_Example;

import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;

public class MainActivity extends AppCompatActivity {

    SwiftApp swiftApp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (swiftApp == null) {
            swiftApp = new SwiftApp();
            swiftApp.applicationCreate();
        }

    }


}
