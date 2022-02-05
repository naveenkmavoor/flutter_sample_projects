import 'package:deeplink_sample/home.dart';
import 'package:deeplink_sample/kids_page_byId.dart';
import 'package:flutter/material.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case HomeApp.routeName:
        return MaterialPageRoute(builder: (_) {
          return const HomeApp();
        });

      case KidsWidgets.routeName:
        if (args is Map) {
          return MaterialPageRoute(builder: (_) {
            return KidsWidgets(
              id: args['kidId'],
            );
          });
        }
        return _onErrorRoute();

      default:
        _onErrorRoute();
    }
    return _onErrorRoute();
  }

  static Route<dynamic> _onErrorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('Route name not found'),
        ),
      );
    });
  }
}
