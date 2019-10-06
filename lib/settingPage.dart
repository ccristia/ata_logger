import 'package:ata_logger/dbmanager.dart';
import 'package:ata_logger/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final textNama = TextEditingController();
  final textJudulNotifikasiClockIn = TextEditingController();
  final textBodyNotifikasiClockIn = TextEditingController();
  final textJudulNotifikasiClockOut = TextEditingController();
  final textBodyNotifikasiClockOut = TextEditingController();
  final double textFormHeight = 70;
  final double textFormFontSize = 18;
  ClockIn _clockin;
  ClockOut _clockOut;
  String fotoProfile;
  String _timeClockIn;
  String _timeClockOut;
  List<String> _waktuClockIn;
  List<String> _waktuClockOut;

  @override
  void dispose() {
    super.dispose();
    textNama.dispose();

    textJudulNotifikasiClockIn.dispose();
    textBodyNotifikasiClockIn.dispose();
    textJudulNotifikasiClockOut.dispose();
    textBodyNotifikasiClockOut.dispose();
  }

  @override
  void initState() {
    super.initState();
    //LOAD DATA DARI DATABASE
    _getDatafromDb();
  }

  _getDatafromDb() {
    DbATAManager().getClockIn().then((value) {
      _timeClockIn = '${value[0].jam}:${value[0].menit}:${value[0].detik}';
      textJudulNotifikasiClockIn.text = value[0].judulClockIn;
      textBodyNotifikasiClockIn.text = value[0].bodyClockIn;
    });

    DbATAManager().getClockOut().then((value) {
      _timeClockOut = '${value[0].jam}:${value[0].menit}:${value[0].detik}';
      textJudulNotifikasiClockOut.text = value[0].judulClockOut;
      textBodyNotifikasiClockOut.text = value[0].bodyClockOut;
    });

    DbATAManager().getProfile().then((value) {
      textNama.text = value[0].nama.toString();
      fotoProfile = value[0].foto.toString();
      print(fotoProfile);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[200],
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 30, right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      'Pengaturan',
                      style: titleBigText,
                    ),
                  ),
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'User Name : ',
                            style: titleSmallText,
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: textFormHeight,
                            child: TextFormField(
                              controller: textNama,
                              maxLength: 20,
                              style: TextStyle(fontSize: textFormFontSize),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  hintText: 'Nama',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                              autocorrect: false,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Reminder Clock In Jam : ',
                                style: titleSmallText,
                              ),
                              FlatButton(
                                child: Text(
                                    _timeClockIn == null
                                        ? 'Set Waktu'
                                        : _timeClockIn.toString(),
                                    style: titleSmallText),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      currentTime: DateTime.now(),
                                      theme:
                                          DatePickerTheme(containerHeight: 210),
                                      showTitleActions: true,
                                      onConfirm: (time) {
                                    print('Confirm : ' + time.toString());
                                    _timeClockIn =
                                        '${time.hour}:${time.minute}:${time.second}';

                                    _waktuClockIn = _timeClockIn.split(':');

                                    setState(() {});
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: textJudulNotifikasiClockIn,
                              maxLength: 20,
                              autocorrect: false,
                              style: TextStyle(fontSize: textFormFontSize),
                              decoration: InputDecoration(
                                labelText: '[ Judul Notifikasi ]',
                                labelStyle: TextStyle(fontSize: 16),
                                hintText: 'Judul Notifikasi',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) return 'Tidak boleh kosong.';

                                return null;
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: textBodyNotifikasiClockIn,
                              maxLength: 50,
                              autocorrect: false,
                              maxLines: 2,
                              style: TextStyle(fontSize: textFormFontSize),
                              decoration: InputDecoration(
                                labelText: '[ Isi Notifikasi ]',
                                labelStyle: TextStyle(fontSize: 16),
                                hintText: 'Isi Notifikasi',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) return 'Tidak boleh kosong.';

                                return null;
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Reminder Clock Out Jam : ',
                                style: titleSmallText,
                              ),
                              FlatButton(
                                child: Text(
                                    _timeClockOut == null
                                        ? 'Set Waktu'
                                        : _timeClockOut.toString(),
                                    style: titleSmallText),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      currentTime: DateTime.now(),
                                      theme:
                                          DatePickerTheme(containerHeight: 210),
                                      showTitleActions: true,
                                      onConfirm: (time) {
                                    print('Confirm : ' + time.toString());
                                    _timeClockOut =
                                        '${time.hour}:${time.minute}:${time.second}';

                                    _waktuClockOut = _timeClockOut.split(':');

                                    setState(() {});
                                  });
                                },
                              )
                            ],
                          ),
                          TextFormField(
                              controller: textJudulNotifikasiClockOut,
                              maxLength: 20,
                              autocorrect: false,
                              style: TextStyle(fontSize: textFormFontSize),
                              decoration: InputDecoration(
                                labelText: '[ Judul Notifikasi ]',
                                labelStyle: TextStyle(fontSize: 16),
                                hintText: 'Judul Notifikasi',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) return 'Tidak boleh kosong.';

                                return null;
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: textBodyNotifikasiClockOut,
                              maxLength: 50,
                              autocorrect: false,
                              maxLines: 2,
                              style: TextStyle(fontSize: textFormFontSize),
                              decoration: InputDecoration(
                                labelText: '[ Isi Notifikasi ]',
                                labelStyle: TextStyle(fontSize: 16),
                                hintText: 'Isi Notifikasi',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) return 'Tidak boleh kosong.';

                                return null;
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: buttonColor),
                        child: Center(
                            child: Text(
                          'Simpan',
                          style: buttonText,
                        )),
                      ),
                      onTap: () {
                        //set manually when user not change default clock in time
                        if (_waktuClockIn == null && _waktuClockOut == null) {
                          _waktuClockIn = _timeClockIn.split(':');
                          _waktuClockOut = _timeClockOut.split(':');
                        } else if (_waktuClockIn != null &&
                            _waktuClockOut == null)
                          _waktuClockOut = _timeClockOut.split(':');
                        else if (_waktuClockIn == null &&
                            _waktuClockOut != null)
                          _waktuClockIn = _timeClockIn.split(':');

                        // SET TIME WHEN ALARM CHANGED
                        _clockin = ClockIn(
                            jam: int.parse(_waktuClockIn[0]),
                            menit: int.parse(_waktuClockIn[1]),
                            detik: int.parse(_waktuClockIn[2]),
                            judulClockIn: textJudulNotifikasiClockIn.text,
                            bodyClockIn: textBodyNotifikasiClockIn.text);

                        print(
                            'save Clock In to db  jam : ${_clockin.jam.toString()} menit : ${_clockin.menit} detik : ${_clockin.detik}');

                        _clockOut = ClockOut(
                            jam: int.parse(_waktuClockOut[0]),
                            menit: int.parse(_waktuClockOut[1]),
                            detik: int.parse(_waktuClockOut[2]),
                            judulClockOut: textJudulNotifikasiClockOut.text,
                            bodyClockOut: textBodyNotifikasiClockOut.text);
                        print(
                            'save Clock Out to db  jam : ${_clockOut.jam} menit : ${_clockOut.menit} detik : ${_clockOut.detik}');

                        Profile _profile = Profile(
                          nama: textNama.text,
                          foto: "'assets/images/nofoto.jpg'",
                          warna: 0,
                        );

                        if (_formKey.currentState.validate()) {
                          // save to DB
                          DbATAManager().updateALL(
                              clockIn: _clockin,
                              clockOut: _clockOut,
                              profile: _profile);

                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text('Info'),
                                  titleTextStyle: titleSmallText,
                                  content: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.check,
                                        size: 50,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        'Data sudah disimpan.',
                                        style: titleText,
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                          child: Container(
                                            width: 100,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: buttonColor),
                                            child: Center(
                                                child: Text(
                                              'OK',
                                              style: buttonText,
                                            )),
                                          ),
                                          onTap: () => Navigator.pushNamed(
                                              context, '/')),
                                    )
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}