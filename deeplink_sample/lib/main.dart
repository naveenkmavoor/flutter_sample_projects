import 'package:deeplink_sample/home.dart';
import 'package:deeplink_sample/path_const.dart';
import 'package:deeplink_sample/route_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  await init();
  runApp(MyApp());
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteServices.generateRoute,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _linkMessage;
  bool _isCreatingLink = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        Navigator.pushNamed(context, dynamicLinkData.link.path,
            arguments: {"kidId": int.parse(queryParams['id'] as String)});
      } else {
        Navigator.pushNamed(context, dynamicLinkData.link.path);
      }
    }).onError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  Future<void> _createDynamicLink(bool short, String link) async {
    setState(() {
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(kUriPrefix + kHomePage),
        uriPrefix: kUriPrefix,
        androidParameters: const AndroidParameters(
            packageName: 'com.example.deeplink_sample', minimumVersion: 0));
    Uri uri;
    if (short) {
      final ShortDynamicLink shortDynamicLink =
          await dynamicLinks.buildShortLink(parameters);
      uri = shortDynamicLink.shortUrl;
    } else {
      uri = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _isCreatingLink = false;
      _linkMessage = uri.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: !_isCreatingLink
                  ? () => _createDynamicLink(false, kHomePage)
                  : null,
              child: const Text('Long Link')),
          ElevatedButton(
              onPressed: !_isCreatingLink
                  ? () => _createDynamicLink(true, kHomePage)
                  : null,
              child: const Text('Short Link')),
          InkWell(
            child: Text(_linkMessage ?? ""),
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: _linkMessage));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Link Copied!')));
            },
            onTap: () {},
          )
        ],
      ),
    ));
  }
}
