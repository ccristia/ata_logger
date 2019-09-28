import 'package:ata_logger/testing.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudahkah Anda ceklok ?',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        // primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ATAPAGE(),
    );
  }
}
