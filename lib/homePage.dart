import 'package:ata_logger/ataListPage.dart';
import 'package:ata_logger/dbmanager.dart';
import 'package:ata_logger/styles/styles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  String clockInTime;
  String clockOutTime;
  bool isClockInDisable = false;
  bool isClockOutDisable = false;
  ATA myATA;
  List<ATA> ataList;
  Database db;
  String today = DateFormat('EEE, d-MMM-yyyy').format(DateTime.now());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _saveClockIn() {
    setState(() {
      if (myATA == null) {
        clockInTime = DateFormat.jm().format(DateTime.now());
        ATA data = ATA(day: today, clockIn: clockInTime, clockOut: null);

        DbATAManager().insertATA(data);

        isClockInDisable = true;
        isClockOutDisable = false;
      }
    });
  }

  _saveClockOut() {
    clockOutTime = DateFormat.jm().format(DateTime.now());
    setState(() {
      ATA data = ATA(
        clockOut: clockOutTime,
      );

      DbATAManager().updateATA(data, today);
      isClockOutDisable = true;
    });
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cekButtonStatus();

    //==========LOCAL NOTIFICATION SECTION==============
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _showNotificationWithSpecificTime(
        id: 0,
        hour: 6,
        minute: 30,
        second: 0,
        title: 'Clock In Reminder',
        msg: 'Mase so Clock In kah... Jangan lupa ya...');

    _showNotificationWithSpecificTime(
        id: 1,
        hour: 15,
        minute: 30,
        second: 0,
        title: 'Clock Out Reminder',
        msg: 'Mase jangan lupa Clock Out ya...');

    // FIREBASE MESSAGING
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  void _cekButtonStatus() {
    String hariIni = DateFormat('EEE, d-MMM-yyyy').format(DateTime.now());
    var hasil = DbATAManager().checkATA(hariIni);
    hasil.then((result) {
      if (result.clockIn.isEmpty && result.clockOut.isEmpty) {
        setState(() {
          isClockInDisable = false;
          isClockOutDisable = false;
        });
      } else if (result.clockIn.isNotEmpty && result.clockOut == null) {
        setState(() {
          isClockInDisable = true;
          isClockOutDisable = false;
          clockInTime = result.clockIn;
        });
      } else if (result.clockOut.isNotEmpty && result.clockOut.isNotEmpty) {
        setState(() {
          isClockInDisable = true;
          clockInTime = result.clockIn;
          isClockOutDisable = true;
          clockOutTime = result.clockOut;
        });
      }
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
      String msg}) async {
    var time = new Time(hour, minute, second);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, msg, time, platformChannelSpecifics);
  }

  Future _showNotificationinPeriodic() async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 3));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
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

    return WillPopScope(
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
                child: ListTile(
                  leading: Text('CekLok Boss!', style: titleBigText),
                  trailing: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListATAPage()));
                    },
                    child: Icon(
                      Icons.date_range,
                      size: 30,
                      color: Colors.blue[300],
                    ),
                  ),
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
    );
  }
}
