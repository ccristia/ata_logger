import 'dart:typed_data';

import 'package:ata_logger/ataListPage.dart';
import 'package:ata_logger/dbmanager.dart';
import 'package:ata_logger/settingPage.dart';

import 'package:ata_logger/styles/styles.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class ATAPAGE extends StatefulWidget {
  @override
  _ATAPAGEState createState() => _ATAPAGEState();
}

class _ATAPAGEState extends State<ATAPAGE> with WidgetsBindingObserver {
  String namaUser;
  String clockInTime;
  String clockOutTime;
  bool isClockInDisable = false;
  bool isClockOutDisable = false;
  ATA myATA;
  List<ATA> ataList;
  Database db;
  String today = DateFormat('EEE, d-MMM-yyyy').format(DateTime.now());

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  _showNotfikasiWeekly(int jam, int menit, int detik) async {
    var time = new Time(jam, menit, detik);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'show weekly title',
        'Weekly notification shown on Monday at approximately ${time.hour}:${time.minute}:${time.second}',
        Day.Monday,
        time,
        platformChannelSpecifics);
  }

  _showNotifikasi() async {
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        color: const Color.fromARGB(255, 255, 0, 0),
        vibrationPattern: vibrationPattern);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'plain title',
        'plain body askla;lkadskadas;dl adshasd adjjasdaldadlk asdl',
        platformChannelSpecifics,
        payload: 'item x');
  }

  _saveClockIn() {
    setState(() {
      today = DateFormat('EEE, d-MMM-yyyy').format(DateTime.now());
    });

    clockInTime = DateFormat.jm().format(DateTime.now());
    ATA data = ATA(day: today, clockIn: clockInTime, clockOut: null);
    print('Hari ini :' + clockInTime);
    DbATAManager().insertATA(data);
    setState(() {
      isClockInDisable = true;
      isClockOutDisable = false;
    });
    _cekButtonStatus();
  }

  _saveClockOut() {
    clockOutTime = DateFormat.jm().format(DateTime.now());
    ATA data = ATA(
      clockOut: clockOutTime,
    );

    if (isClockInDisable == true) {
      DbATAManager().updateATA(data, today);
      setState(() {
        isClockInDisable = true;
        isClockOutDisable = true;
      });
    } else if (isClockInDisable == false) {
      clockOutTime = DateFormat.jm().format(DateTime.now());
      ATA data = ATA(day: today, clockIn: null, clockOut: clockOutTime);

      DbATAManager().insertATA(data);
      setState(() {
        isClockOutDisable = true;
        isClockInDisable = true;
      });
    }
    _cekButtonStatus();
  }

  _setClockInReminder() {
    DbATAManager().getClockIn().then((data) {
      Day _currentDay;
      switch (DateTime.now().weekday) {
        case 1:
          _currentDay = Day.Monday;
          break;
        case 2:
          _currentDay = Day.Tuesday;
          break;
        case 3:
          _currentDay = Day.Wednesday;
          break;
        case 4:
          _currentDay = Day.Thursday;
          break;
        case 5:
          _currentDay = Day.Friday;
          break;
        default:
          _currentDay = Day.Monday;
          break;
      }
      _showNotificationWithSpecificTime(
          id: 0,
          hour: data[0].jam,
          minute: data[0].menit,
          second: data[0].detik,
          title: data[0].judulClockIn,
          msg: data[0].bodyClockIn,
          day: _currentDay);
    });

    print('clock in reminder executing...');
  }

  _setClockOutReminder() {
    DbATAManager().getClockOut().then((data) {
      Day _currentDay;
      switch (DateTime.now().weekday) {
        case 1:
          _currentDay = Day.Monday;
          break;
        case 2:
          _currentDay = Day.Tuesday;
          break;
        case 3:
          _currentDay = Day.Wednesday;
          break;
        case 4:
          _currentDay = Day.Thursday;
          break;
        case 5:
          _currentDay = Day.Friday;
          break;
        default:
          _currentDay = Day.Monday;
          break;
      }
      _showNotificationWithSpecificTime(
          id: 1,
          hour: data[0].jam,
          minute: data[0].menit,
          second: data[0].detik,
          title: data[0].judulClockOut,
          msg: data[0].bodyClockOut,
          day: _currentDay);
    });

    print('clock out reminder executing...');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("app Paused");
    } else if (state == AppLifecycleState.resumed) {
      print("App resumed");
      _cekButtonStatus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    print('App Init');
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cekButtonStatus();
  }

  void _cekButtonStatus() {
    print('Cek Button Status');

    //==========LOCAL NOTIFICATION SECTION==============
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    String hariIni = DateFormat('EEE, d-MMM-yyyy').format(DateTime.now());
    DbATAManager().checkATA(hariIni).then((result) {
      if (result == null) {
        setState(() {
          isClockInDisable = false;
          isClockOutDisable = false;
        });
        print('no data in database - all button enabled');

        _setClockInReminder();
        _setClockOutReminder();
      } else if (result.clockIn != null && result.clockOut == null) {
        setState(() {
          isClockInDisable = true;
        });
        _setClockOutReminder();
        print('button clock in disable');
      } else {
        setState(() {
          isClockInDisable = true;
          isClockOutDisable = true;
        });
        print('semua button disable tidak ada notifikasi ');
      }
    });

    //get profile name
    DbATAManager().getProfile().then((value) {
      setState(() {
        namaUser = value[0].nama;
      });
      // print(namaUser);
    });
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("OK"),
          content: Text("Siap Laksanakan."),
        );
      },
    );
  }

  Future _showNotificationWithSpecificTime(
      {int id,
      int hour,
      int minute,
      int second,
      String title,
      String msg,
      Day day}) async {
    var time = new Time(hour, minute, second);

    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        color: const Color.fromARGB(255, 255, 0, 0),
        vibrationPattern: vibrationPattern);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id, title, msg, day, time, platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future<bool> _exitApp() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Mau Keluar Aplikasi ?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Tidak'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                    child: Text('Ya'),
                    onPressed: () => SystemChannels.platform
                        .invokeMethod('SystemNavigator.pop'),
                  ),
                ],
              ));
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () => _exitApp(),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                    )),
                Positioned(
                  top: -150,
                  left: -130,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: buttonColor.withOpacity(0.8),
                    ),
                  ),
                ),
                Positioned(
                  //top: 00,
                  bottom: -150,
                  right: -250,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: buttonColor.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 70,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: buttonColor.withOpacity(0.3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text('Hi, ' + namaUser.toString()),
                    actions: <Widget>[
                      InkWell(
                        onTap: () {
                          var _day = DateTime.now().weekday;
                          print(_day);
                        },
                        child: Icon(
                          Icons.settings,
                          size: 30,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            // Navigator.pushNamed(context, '/settingPage'),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingPage())),
                        child: Icon(
                          Icons.settings,
                          size: 30,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () =>
                            // Navigator.pushNamed(context, '/listPage'),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListATAPage())),
                        child: Icon(
                          Icons.date_range,
                          size: 30,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.15,
                  top: screenHeight * 0.25,
                  child: Card(
                    elevation: 10,
                    child: Container(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                DateFormat('EEE, d-MMM-yyyy')
                                    .format(DateTime.now())
                                    .toString(),
                                style: titleText),
                            SizedBox(height: 50),
                            InkWell(
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: isClockInDisable
                                        ? buttonDisableColor
                                        : buttonColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text('Clock In', style: buttonText)),
                              ),
                              onTap: () =>
                                  isClockInDisable ? null : _saveClockIn(),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Clock In : ' + clockInTime.toString(),
                              style: titleSmallText,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 25),
                            InkWell(
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: isClockOutDisable
                                          ? buttonDisableColor
                                          : buttonColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child:
                                          Text('Clock Out', style: buttonText)),
                                ),
                                onTap: () =>
                                    isClockOutDisable ? null : _saveClockOut()),
                            SizedBox(height: 10),
                            Text(
                              'Clock Out : ' + clockOutTime.toString(),
                              style: titleSmallText,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
