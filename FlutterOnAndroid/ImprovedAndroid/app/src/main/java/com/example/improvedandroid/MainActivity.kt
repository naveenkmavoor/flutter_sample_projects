package com.example.improvedandroid

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        // Instantiate a FlutterEngine.
        var flutterEngine = FlutterEngine(this)

        // Configure an initial route.
        flutterEngine.navigationChannel.setInitialRoute("/home");

        // Start executing Dart code to pre-warm the FlutterEngine.
        flutterEngine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        )

        // Cache the FlutterEngine to be used by FlutterActivity.
        FlutterEngineCache
                .getInstance()
                .put("my_engine_id", flutterEngine)
        val button = findViewById<Button>(R.id.button)
        button.setOnClickListener {
            startActivity(
                    FlutterActivity
                            .withCachedEngine("my_engine_id")
                            .build(this)
            )
        }
        //use method channel to change route using same flutter engine

        // Set platform channel inside a button or function if initialized outside error is thrown
        val flutterChannel = MethodChannel(flutterViewEngine.engine.dartExecutor, "dev.flutter.example/cell")
        // Tell Flutter about the string value so Flutter could show the string val in its
        // own widget tree.
        flutterChannel.invokeMethod("SetStringVal", "Hello from Android to Flutter")

        // Receive binary messages from Dart on Android.
        // This code can be added to a FlutterActivity subclass, typically
        // in onCreate.
        flutterView.setMessageHandler("foo") { message, reply ->
            message.order(ByteOrder.nativeOrder())
            val x = message.double
            val n = message.int
            Log.i("MSG", "Received: $x and $n")
            reply.reply(null)
        }

    }
}