import 'package:flutter/material.dart';
import 'package:sample_webview/webviewscreen.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        Homepage.routeName: (ctx) => Homepage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _launchInWebViewWithwebview(String url) async {
//Attach token to the webview incase an authentication is required.
    //    final Uri uri = Uri(
    //     scheme: 'http',
    //     path: 'www.woolha.com',
    //     queryParameters: {
    //       'name': 'Woolha dot com',
    //       'about': 'Flutter Dart'
    //     }
    // );
    if (!await launch(
      url,
      enableJavaScript: true,
      statusBarBrightness: Brightness.light,
      forceWebView: true,
      enableDomStorage: true,
    )) {
      throw 'Could not launch $url';
    }
    // closeWebView(); To close the webview
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Parentry App"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Homepage.routeName);
            },
            child: Text("Press"),
          ),
        ));
    //     body: Center(
    //         // child: Link(
    //         //     target: LinkTarget.self,
    //         //     uri: Uri.parse(
    //         //       "https://monitor.parentry.app/",
    //         //     ),
    //         //     builder: (context, followLink) {
    //         //       return ElevatedButton(
    //         //           onPressed: followLink, child: const Text('Go to browser'));
    //         //     }),
    //         child: ElevatedButton(
    //   child: const Text('Open webview'),
    //   onPressed: () async {
    //     _launchInWebViewWithwebview("https://mbp-beta.herokuapp.com/");

    //     // _launchInWebViewWithwebview(
    //     //     "https://www.youtube.com/watch?v=qYxRYB1oszw");
    //   },
    //   // ),
    // )));
  }
}
