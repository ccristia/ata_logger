import 'package:ata_logger/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ataListPage.dart';
import 'homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

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
      routes: {
        '/': (context) => ATAPAGE(),
        '/settingPage': (context) => SettingPage(),
        '/listPage': (context) => ListATAPage(),
      },
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ATAPAGE(),
//     );
//   }
// }
