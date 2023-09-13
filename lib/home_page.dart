import 'package:flutter/material.dart';

class RoutesName {
  // ignore: non_constant_identifier_names
  static const String FIRST_PAGE = '/first_page';
  // ignore: non_constant_identifier_names
  static const String SECOND_PAGE = '/second_page';
}

class HomePage extends StatelessWidget {
  final Widget child;

  const HomePage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}

class UnknownPage extends StatelessWidget{
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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
