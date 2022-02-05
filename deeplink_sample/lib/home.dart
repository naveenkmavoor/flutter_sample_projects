import 'dart:ffi';
import 'package:flutter/material.dart';

class HomeApp extends StatelessWidget {
  static const routeName = '/home';
  const HomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Redirected to home screen'),
      ),
    );
  }
}
