import 'package:flutter/material.dart';
import 'router.dart';
import 'sample_app.dart';
import 'package:provider/provider.dart';
import 'states.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     title: "Flutter Navigaton 2.0",
  //     routerDelegate: HomeRouterDelegate(),
  //     routeInformationParser: HomeRouteInformationParser(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<PageNotifier>(create: (context) => PageNotifier())
    ], child: const SampleApp());
  }
}
