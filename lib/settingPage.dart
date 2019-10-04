import 'package:ata_logger/dbmanager.dart';
import 'package:ata_logger/styles/styles.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _formKey = GlobalKey<FormState>();
  final textNama = TextEditingController();
  final textJamClockIn = TextEditingController();
  final textMenitClockIn = TextEditingController();
  final textDetikClockIn = TextEditingController();
  final textJamClockOut = TextEditingController();
  final textMenitClockOut = TextEditingController();
  final textDetikClockOut = TextEditingController();
  final textJudulNotifikasiClockIn = TextEditingController();
  final textBodyNotifikasiClockIn = TextEditingController();
  final textJudulNotifikasiClockOut = TextEditingController();
  final textBodyNotifikasiClockOut = TextEditingController();
  final double textFormHeight = 70;
  final double textFormFontSize = 18;
  String fotoProfile;

  @override
  void dispose() {
    super.dispose();
    textNama.dispose();
    textJamClockIn.dispose();
    textMenitClockIn.dispose();
    textDetikClockIn.dispose();
    textJamClockOut.dispose();
    textMenitClockOut.dispose();
    textDetikClockOut.dispose();
    textJudulNotifikasiClockIn.dispose();
    textBodyNotifikasiClockIn.dispose();
    textJudulNotifikasiClockOut.dispose();
    textBodyNotifikasiClockOut.dispose();
  }

  @override
  void initState() {
    super.initState();
    //LOAD DATA DARI DATABASE
    DbATAManager().getClockIn().then((value) {
      textJamClockIn.text = value[0].jam.toString();
      textMenitClockIn.text = value[0].menit.toString();
      textDetikClockIn.text = value[0].detik.toString();
      textJudulNotifikasiClockIn.text = value[0].judulClockIn;
      textBodyNotifikasiClockIn.text = value[0].bodyClockIn;
    });

    DbATAManager().getClockOut().then((value) {
      textJamClockOut.text = value[0].jam.toString();
      textMenitClockOut.text = value[0].menit.toString();
      textDetikClockOut.text = value[0].detik.toString();
      textJudulNotifikasiClockOut.text = value[0].judulClockOut;
      textBodyNotifikasiClockOut.text = value[0].bodyClockOut;
    });

    DbATAManager().getProfile().then((value) {
      textNama.text = value[0].nama.toString();
      fotoProfile = value[0].foto.toString();
      print(fotoProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 30, right: 15),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.blue.withOpacity(0.3),
                    // backgroundImage: AssetImage(fotoProfile),
                    backgroundImage: fotoProfile == ''
                        ? AssetImage('assets/images/nofoto.jpg')
                        : AssetImage('assets/images/nofoto.jpg'),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  // width: 230,
                  height: textFormHeight,
                  child: TextFormField(
                    controller: textNama,
                    maxLength: 20,
                    style: TextStyle(fontSize: textFormFontSize),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintText: 'Nama',
                        icon: Icon(Icons.account_box),
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
                SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Clock In : ',
                          style: titleText,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Text('Jam', style: titleSmallText),
                                SizedBox(width: 5),
                                Container(
                                  width: 40,
                                  height: textFormHeight,
                                  child: TextFormField(
                                      controller: textJamClockIn,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      maxLength: 2,
                                      style:
                                          TextStyle(fontSize: textFormFontSize),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty)
                                          return '';
                                        else if (int.parse(value) > 24)
                                          return '';
                                        else
                                          return null;
                                      }),
                                ),
                                SizedBox(width: 20),
                                Text('Menit', style: titleSmallText),
                                SizedBox(width: 5),
                                Container(
                                  width: 40,
                                  height: textFormHeight,
                                  child: TextFormField(
                                      controller: textMenitClockIn,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 2,
                                      style:
                                          TextStyle(fontSize: textFormFontSize),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty)
                                          return '';
                                        else if (int.parse(value) > 60)
                                          return '';
                                        else
                                          return null;
                                      }),
                                ),
                                SizedBox(width: 20),
                                Text('Detik', style: titleSmallText),
                                SizedBox(width: 5),
                                Container(
                                  width: 40,
                                  height: textFormHeight,
                                  child: TextFormField(
                                      controller: textDetikClockIn,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 2,
                                      style:
                                          TextStyle(fontSize: textFormFontSize),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty)
                                          return '';
                                        else if (int.parse(value) > 60)
                                          return '';
                                        else
                                          return null;
                                      }),
                                ),
                              ],
                            ),
                          ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Clock Out : ',
                          style: titleText,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Text('Jam', style: titleSmallText),
                                SizedBox(width: 5),
                                Container(
                                  width: 40,
                                  height: textFormHeight,
                                  child: TextFormField(
                                      controller: textJamClockOut,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      maxLength: 2,
                                      style:
                                          TextStyle(fontSize: textFormFontSize),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty)
                                          return '';
                                        else if (int.parse(value) > 24)
                                          return '';
                                        else
                                          return null;
                                      }),
                                ),
                                SizedBox(width: 20),
                                Text('Menit', style: titleSmallText),
                                SizedBox(width: 5),
                                Container(
                                  width: 40,
                                  height: textFormHeight,
                                  child: TextFormField(
                                      controller: textMenitClockOut,
                                      keyboardType: TextInputType.number,
                                      maxLength: 2,
                                      style:
                                          TextStyle(fontSize: textFormFontSize),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty)
                                          return '';
                                        else if (int.parse(value) > 60)
                                          return '';
                                        else
                                          return null;
                                      }),
                                ),
                                SizedBox(width: 20),
                                Text('Detik', style: titleSmallText),
                                SizedBox(width: 5),
                                Container(
                                  width: 40,
                                  height: textFormHeight,
                                  child: TextFormField(
                                      controller: textDetikClockOut,
                                      keyboardType: TextInputType.number,
                                      maxLength: 2,
                                      style:
                                          TextStyle(fontSize: textFormFontSize),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty)
                                          return '';
                                        else if (int.parse(value) > 60)
                                          return '';
                                        else
                                          return null;
                                      }),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
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
                      ClockIn _clockin = ClockIn(
                          jam: int.parse(textJamClockIn.text),
                          menit: int.parse(textMenitClockIn.text),
                          detik: int.parse(textDetikClockIn.text),
                          judulClockIn: textJudulNotifikasiClockIn.text,
                          bodyClockIn: textBodyNotifikasiClockIn.text);

                      ClockOut _clockOut = ClockOut(
                          jam: int.parse(textJamClockOut.text).toInt(),
                          menit: int.parse(textMenitClockOut.text),
                          detik: int.parse(textDetikClockOut.text),
                          judulClockOut: textJudulNotifikasiClockOut.text,
                          bodyClockOut: textBodyNotifikasiClockOut.text);
                      // print(textJamClockOut.text);
                      Profile _profile = Profile(
                        nama: textNama.text,
                        foto: "'assets/images/nofoto.jpg'",
                        warna: 0,
                      );

                      if (_formKey.currentState.validate()) {
                        print('data disimpan');
                        // Scaffold.of(context).showSnackBar(SnackBar(
                        //   content: Text('Data Telah Disimpan.'),
                        // ));

                        DbATAManager().updateALL(
                            clockIn: _clockin,
                            clockOut: _clockOut,
                            profile: _profile);
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
    );
  }
}
