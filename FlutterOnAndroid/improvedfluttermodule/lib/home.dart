import 'package:flutter/material.dart' ;

class Home extends StatelessWidget {
  static const routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Center(child: Container(alignment: Alignment.center,height: 200,width: 200,color: Colors.teal,child: Text("Hello from flutter home page"),)),));
  }
}
