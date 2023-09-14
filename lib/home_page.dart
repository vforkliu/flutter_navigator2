import 'package:flutter/material.dart';

class RoutesName {
  // ignore: non_constant_identifier_names
  static const String FIRST_PAGE = '/first_page';

  // ignore: non_constant_identifier_names
  static const String SECOND_PAGE = '/second_page';
}

class HomePage extends StatelessWidget {
  final ValueChanged<String> onTapped;

  const HomePage({super.key, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              onTapped(RoutesName.FIRST_PAGE);
            },
            child: const Text("Go to first page")),
      ),
    );
  }
}

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('404!'),
      ),
    );
  }
}

class PageHandle extends Page {
  final String pathName;

  PageHandle({required this.pathName}) : super(key: ValueKey(pathName));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return PageScreen(pathName: pathName);
      },
    );
  }
}

class PageScreen extends StatelessWidget {
  final String pathName;

  const PageScreen({super.key, required this.pathName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("path name:$pathName"),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          Container(
            child: const Center(
              child: Text("FIRST PAGE"),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.SECOND_PAGE);
              },
              child: const Text("NAVIGATE")),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          Container(
            child: Center(
              child: Text("SECOND PAGE"),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, RoutesName.SECOND_PAGE);
              },
              child: Text("NAVIGATE")),
        ],
      ),
    );
  }
}
