import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'screens.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);


class HomeRoutePath {
  final String? pathName;
  final bool isUnknown;

  HomeRoutePath.home()
      : pathName = null,
        isUnknown = false;

  HomeRoutePath.otherPage(this.pathName) : isUnknown = false;

  HomeRoutePath.unKnown()
      : pathName = null,
        isUnknown = true;

  bool get isHomePage => pathName == null;

  bool get isOtherPage => pathName != null;

  Map toJson() => {
    "pathName": pathName,
    "isUnknown": isUnknown,
    "isHomePage": isHomePage,
    "isOtherPage": isOtherPage
  };

  @override
  String toString(){
    return jsonEncode(toJson());
  }
}

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
      if (pathName.isEmpty) return HomeRoutePath.unKnown();
      return HomeRoutePath.otherPage(pathName);
    }

    return HomeRoutePath.unKnown();
  }

  @override
  RouteInformation? restoreRouteInformation(HomeRoutePath configuration) {
    logger.d("<HomeRouteInformationParser> restore route configuration: $configuration");
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse('/error'));
    }
    if (configuration.isHomePage) return RouteInformation(uri: Uri.parse('/'));
    if (configuration.isOtherPage) {
      return RouteInformation(uri: Uri.parse('/${configuration.pathName}'));
    }

    return null;
  }
}

class HomeRouterDelegate extends RouterDelegate<HomeRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<HomeRoutePath> {
  String? pathName;
  bool isError = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  HomeRoutePath get currentConfiguration {
    logger.d("<HomeRouterDelegate> get current configuration:$isError, ${pathName ?? "null"}");
    if (isError) return HomeRoutePath.unKnown();

    if (pathName == null) return HomeRoutePath.home();

    return HomeRoutePath.otherPage(pathName);
  }

  void onTapped(String path) {
    pathName = path;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("<HomeRouterDelegate> build navigator");
    return Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: const ValueKey('HomePage'),
            child: HomePage(
              onTapped: (String path) {
                pathName = path;
                notifyListeners();
              },
            ),
          ),
          if (isError)
            const MaterialPage(key: ValueKey('UnknownPage'), child: UnknownPage())
          else if (pathName != null)
            MaterialPage(
              key: ValueKey(pathName!),
              child: PageScreen(pathName: pathName!,)
            )
            // PageHandle(pathName: pathName!)
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;

          pathName = null;
          isError = false;
          notifyListeners();

          return true;
        });
  }

  @override
  Future<void> setNewRoutePath(HomeRoutePath configuration) async {

    if (configuration.isUnknown) {
      logger.d("<HomeRouterDelegate> set new route path: unknown");
      pathName = null;
      isError = true;
      return;
    }

    if (configuration.isOtherPage) {
      if (configuration.pathName != null) {
        logger.d("<HomeRouterDelegate> set new route path: other page");
        pathName = configuration.pathName;
        isError = false;
        return;
      } else {
        isError = true;
        return;
      }
    } else {
      pathName = null;
    }
  }
}