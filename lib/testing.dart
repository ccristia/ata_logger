import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Text('Test Page'),
        ),
      ),
    );
  }
}
