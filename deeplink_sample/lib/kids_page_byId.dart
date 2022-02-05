import 'package:flutter/material.dart';

class KidsWidgets extends StatelessWidget {
  static const routeName = "/kidpage";
  final int? id;
  const KidsWidgets({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Kids page id : '),
      ),
    );
  }
}
