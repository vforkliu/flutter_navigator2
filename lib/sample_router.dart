import 'enums.dart';
import 'sample_screens.dart';
import 'states.dart';
import 'package:flutter/material.dart';

class AppRoute {
  final PageName? pageName;
  final bool _isUnknown;

  AppRoute.home()
      : pageName = PageName.home,
        _isUnknown = false;

  AppRoute.contact()
      : pageName = PageName.contact,
        _isUnknown = false;

  AppRoute.about()
      : pageName = PageName.about,
        _isUnknown = false;

  AppRoute.services()
      : pageName = PageName.services,
        _isUnknown = false;

  AppRoute.unknown()
      : pageName = null,
        _isUnknown = true;

  //Used to get the current path
  bool get isHome => pageName == PageName.home;

  bool get isAbout => pageName == PageName.about;

  bool get isContact => pageName == PageName.contact;

  bool get isServices => pageName == PageName.services;

  bool get isUnknown => _isUnknown;
}

//This holds an unknown path typed into the uri
String? _unknownPath;

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return AppRoute.home();
    }

    //If path includes more than one segement, go to 404
    if (uri.pathSegments.length > 1) {
      _unknownPath = routeInformation.location;
      return AppRoute.unknown();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments.first == PageName.about.name) {
        return AppRoute.about();
      }

      if (uri.pathSegments.first == PageName.contact.name) {
        return AppRoute.contact();
      }

      if (uri.pathSegments.first == PageName.services.name) {
        return AppRoute.services();
      }
    }

    _unknownPath = uri.path;
    return AppRoute.unknown();
  }

//This passes route information to the parseRouteInformation method depending on the current AppRoute
  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) {
    if (configuration.isAbout) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    if (configuration.isUnknown) {
      return RouteInformation(location: _unknownPath);
    }

    if (configuration.isContact) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    if (configuration.isServices) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    return const RouteInformation(location: "/");
  }

//Get Route Information depending on the PageName passed
  RouteInformation _getRouteInformation(String page) {
    return RouteInformation(location: "/$page");
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final PageNotifier notifier;

  AppRouterDelegate({required this.notifier});

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          if (notifier.isUnknown) const MaterialPage(child: PageNotFound()),
          if (!notifier.isUnknown) const MaterialPage(child: HomePage()),
          if (notifier.pageName == PageName.home)
            const MaterialPage(child: HomePage()),
          if (notifier.pageName == PageName.about)
            const MaterialPage(child: AboutPage()),
          if (notifier.pageName == PageName.contact)
            const MaterialPage(child: ContactPage()),
          if (notifier.pageName == PageName.services)
            const MaterialPage(child: ServicesPage()),
        ],
        onPopPage: (route, result) => route.didPop(result));
  }

//currentConfiguration is called whenever there might be a change in route
//It checks for the current page or route and return a new route information
//This is what populates our browser history
  @override
  AppRoute? get currentConfiguration {
    if (notifier.isUnknown) {
      return AppRoute.unknown();
    }

    if (notifier.pageName == PageName.home) {
      return AppRoute.home();
    }

    if (notifier.pageName == PageName.about) {
      return AppRoute.about();
    }

    if (notifier.pageName == PageName.contact) {
      return AppRoute.contact();
    }

    if (notifier.pageName == PageName.services) {
      return AppRoute.services();
    }

    return AppRoute.unknown();
  }

//This is called whenever the system detects a new route is passed
//It checks the current route through the configuration and uses that to update the notifier
  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    if (configuration.isUnknown) {
      _updateRoute(page: null, isUnknown: true);
    }

    if (configuration.isAbout) {
      _updateRoute(page: PageName.about);
    }

    if (configuration.isContact) {
      _updateRoute(page: PageName.contact);
    }

    if (configuration.isServices) {
      _updateRoute(page: PageName.services);
    }

    if (configuration.isHome) {
      _updateRoute(page: PageName.home);
    }
  }

  _updateRoute({PageName? page, bool isUnknown = false}) {
    notifier.changePage(page: page, unknown: isUnknown);
  }
}
