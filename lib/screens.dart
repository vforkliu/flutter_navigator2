import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<String> onTapped;

  const HomePage({super.key, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: TextButton(
            onPressed: () {
              onTapped("first_page");
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
      appBar: AppBar(title:const Text("Unknown")),
      body: const Center(
        child: Text('404!'),
      ),
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