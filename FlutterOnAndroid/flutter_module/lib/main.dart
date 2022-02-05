import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main()=> runApp(chooseWidget(window.defaultRouteName));


@pragma("vm:entry-point")
void showCell() => runApp( MyApp());

Widget chooseWidget(String route){

  switch (route){
    case "showCell" : print("Executed"); return Initial();
    default : return Default();
  }
}


class Initial extends StatelessWidget {
  const Initial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container(alignment: Alignment.center,color: Colors.teal,child: Text("Hello From Flutter side"),)));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? val;
  @override
  void initState() {
    const channel = MethodChannel('dev.flutter.example/cell');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'SetStringVal') {
        setState(() {
          val = call.arguments as String;

        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container(alignment: Alignment.center,color: Colors.green,child: Text(val??"Oops! failed to get the data."),)));
  }
}


class Default extends StatelessWidget {
  const Default({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container( alignment: Alignment.center,color: Colors.red,child: Text("Flutter side executed by default"),)));
  }
}