import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'home_route_path.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class HomeRouterDelegate extends RouterDelegate<HomeRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<HomeRoutePath> {
  String? pathName;
  bool isError = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  HomeRoutePath get currentConfiguration {
    logger.d("<HomeRouterDelegate> get current configuration:$isError, ${pathName ?? "null"}");
    if (isError) return HomeRoutePath.unKown();

    if (pathName == null) return HomeRoutePath.home();

    return HomeRoutePath.otherPage(pathName);
  }

  void onTapped(String path) {
    pathName = path;
    if (kDebugMode) {
      print(pathName);
    }
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
            PageHandle(pathName: pathName!)
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

    if (configuration.isUnkown) {
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
