package com.example.androidpart

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.ViewGroup
import android.widget.Button
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity : AppCompatActivity() {

    private var flutterView: FlutterView? = null

    private lateinit var flutterViewEngine: FlutterViewEngine

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val engine = FlutterEngine(applicationContext)
        engine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(
                        FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                        "showCell"))


        val button = findViewById<Button>(R.id.button)

        button.setOnClickListener {
            flutterViewEngine = FlutterViewEngine(engine)
            val flutterView = FlutterView(this)
            flutterViewEngine.attachToActivity(this)
            val matchParentLayout = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)

     // Set platform channel inside a button or function if initialized outside error is thrown
            val flutterChannel = MethodChannel(flutterViewEngine.engine.dartExecutor, "dev.flutter.example/cell")
            // Tell Flutter about the string value so Flutter could show the string val in its
            // own widget tree.
            flutterChannel.invokeMethod("SetStringVal", "Hello from Android to Flutter")

            flutterViewEngine.attachFlutterView(flutterView)
            addContentView(flutterView,matchParentLayout)
        }
    }
}