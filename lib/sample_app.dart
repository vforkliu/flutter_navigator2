import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sample_router.dart';
import 'states.dart';

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: AppRouteInformationParser(),
      routerDelegate:
      AppRouterDelegate(notifier: Provider.of<PageNotifier>(context)),
      title: 'Navigator 2.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}