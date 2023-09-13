import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'home_route_path.dart';

class HomeRouterDelegate extends RouterDelegate<HomeRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<HomeRoutePath> {
  String? pathName;
  bool isError = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  HomeRoutePath get currentConfiguration {
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
    return Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: ValueKey('HomePage'),
            child: HomePage(
              onTapped: (String path) {
                pathName = path;
                notifyListeners();
              },
            ),
          ),
          if (isError)
            MaterialPage(key: ValueKey('UnknownPage'), child: UnkownPage())
          else if (pathName != null)
            MaterialPage(
                key: ValueKey(pathName),
                child: PageHandle(
                  pathName: pathName,
                ))
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
      pathName = null;
      isError = true;
      return;
    }

    if (configuration.isOtherPage) {
      if (configuration.pathName != null) {
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
