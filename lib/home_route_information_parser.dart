import 'package:flutter/widgets.dart';
import 'home_route_path.dart';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class HomeRouteInformationParser extends RouteInformationParser<HomeRoutePath> {
  @override
  Future<HomeRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {

    final uri = routeInformation.uri;
    logger.d("<HomeRouteInformationParser> parse route information uri: $uri");
    if (uri.pathSegments.isEmpty) {
      return HomeRoutePath.home();
    }

    if (uri.pathSegments.length == 1) {
      final pathName = uri.pathSegments.elementAt(0).toString();
      if (pathName.isEmpty) return HomeRoutePath.unKown();
      return HomeRoutePath.otherPage(pathName);
    }

    return HomeRoutePath.unKown();
  }

  @override
  RouteInformation? restoreRouteInformation(HomeRoutePath configuration) {
    logger.d("<HomeRouteInformationParser> restore route configuration: $configuration");
    if (configuration.isUnkown) {
      return RouteInformation(uri: Uri.parse('/error'));
    }
    if (configuration.isHomePage) return RouteInformation(uri: Uri.parse('/'));
    if (configuration.isOtherPage) {
      return RouteInformation(uri: Uri.parse('/${configuration.pathName}'));
    }

    return null;
  }
}
