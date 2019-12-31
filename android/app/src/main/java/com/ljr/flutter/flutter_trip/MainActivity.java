package com.ljr.flutter.flutter_trip;

import android.os.Bundle;

import com.chase.plugin.asr.AsrPlugin;

import org.devio.flutter.splashscreen.SplashScreen;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    SplashScreen.show(this, true);//
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    AsrPlugin.registerWith(registrarFor("com.chase.plugin.asr.AsrPlugin"));
  }
}
