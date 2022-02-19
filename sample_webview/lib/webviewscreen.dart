import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/homepage';
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  late WebViewController _controller;
  late String? _link;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _goBack(context),
        child: WebView(
          initialUrl: 'https://mbp-beta.herokuapp.com/',
          // initialUrl: 'http://192.168.1.10:8080/app',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controllerCompleter.future.then((value) {
              _controller = value;
            });
            _controllerCompleter.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>{
            // Set Javascript Channel to WebView
            _extractDataJSChannel(context),
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            print('Page finished loading: $url');
            // In the final result page we check the url to make sure  it is the last page.
            // _controller.runJavascript(
            //     "(function(){document.getElementById('appbar').style.display='none'})();");
            // _controller.runJavascript(
            //     "(function(){Site.postMessage(window.document.getElementById('linkBadge'))})();");

            String email = "c4@mailinator.com";
            _controller.runJavascript(
                "document.getElementById('TextField0').value='$email';");
            String password = "123456";
            _controller.runJavascript(
                "document.getElementById('TextField3').value='$password';");
            await Future.delayed(const Duration(seconds: 1));
            _controller
                .runJavascript("document.getElementById('btn-form').click();");
          },
        ),

        //  WebView(
        //   zoomEnabled: false,
        //   onPageFinished: (url) {
        //     _controller.runJavascript(
        //         "(function(){document.getElementByTagName('header')[0].style.display='none'})();");
        // "document.getElementByTagName('header')[0].style.display='none';");
        //   },
        //   onPageStarted: (url) {
        //     print('Page started loading: $url');
        //   },
        //   onProgress: (progress) =>
        //       const Center(child: CircularProgressIndicator()),
        //   initialUrl: 'https://mbp-beta.herokuapp.com/',
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onWebViewCreated: (WebViewController webViewController) {
        //     _controllerCompleter.future.then((value) => _controller = value);
        //     _controllerCompleter.complete(webViewController);
        //   },
        // ),
      ),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Site',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        _link = pageBody;
        // print('------------------------ RESULT: $pageBody');
      },
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Do you want to exit monitor app?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes'),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }
}
