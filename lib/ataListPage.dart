import 'package:ata_logger/dbmanager.dart';
import 'package:ata_logger/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListATAPage extends StatefulWidget {
  ListATAPage({Key key}) : super(key: key);

  _ListATAPageState createState() => _ListATAPageState();
}

class _ListATAPageState extends State<ListATAPage> {
  List<ATA> ataList;
  ATA myATA;
  bool isCompletedSwipe = false;

  String _filterDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await Navigator.pushNamed(context, '/');
          return false;
        },
        child: Container(
          color: Colors.blue[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Daftar Absensi',
                  style: titleBigText,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Text('Tampilkan Tanggal : ', style: titleSmallText),
                    GestureDetector(
                      child: Container(
                        child: Text(
                            _filterDate == null
                                ? 'SEMUA'
                                : _filterDate.toString(),
                            style: titleCalenderText),
                      ),
                      onTap: () {
                        Future<DateTime> _selectedDate = showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2030),
                        );

                        _selectedDate.then((value) {
                          if (value != null) {
                            _filterDate =
                                DateFormat('EEE, d-MMM-yyyy').format(value);
                            print(_filterDate);
                            DbATAManager().getATAListByDay(_filterDate);
                            setState(() {});
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _filterDate == null
                      ? DbATAManager().getATAList()
                      : DbATAManager().getATAListByDay(_filterDate),
                  builder: (context, snapshot) {
                    ataList = snapshot.data;

                    if (ataList.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Tidak ada Record',
                            style: titleText,
                          ),
                          RaisedButton(
                            child: Text('Refresh', style: titleText),
                            onPressed: () => Navigator.of(context).pop(true),
                          )
                        ],
                      ));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData) {
                      // ataList = snapshot.data;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: ataList == null ? 0 : ataList.length,
                        itemBuilder: (BuildContext contex, int index) {
                          ATA ata = ataList[index];

                          if (ata.clockIn == null || ata.clockOut == null) {
                            isCompletedSwipe = false;
                            //print(isCompletedSwipe);
                          } else {
                            isCompletedSwipe = true;
                            //  print(isCompletedSwipe);
                          }

                          return InkWell(
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              elevation: 10,
                              child: Container(
                                color: Colors.white,
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1, color: Colors.grey))),
                                    child: CircleAvatar(
                                      maxRadius: 20,
                                      backgroundColor: isCompletedSwipe
                                          ? Colors.green
                                          : Colors.yellow[900],
                                      child: isCompletedSwipe
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      // '' + ata.day.toString(),
                                      '' + ata.day.toString(),
                                      style: titleSmallText,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/login.png',
                                        height: 17,
                                        width: 17,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '' + ata.clockIn.toString(),
                                        style: titleSmallText,
                                      ),
                                      SizedBox(width: 20),
                                      Image.asset(
                                        'assets/images/logout.png',
                                        height: 17,
                                        width: 17,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '' + ata.clockOut.toString(),
                                        style: titleSmallText,
                                      ),
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                    child: Icon(
                                      Icons.delete,
                                      size: 25,
                                      color: Colors.red[400],
                                    ),
                                    onTap: () {
                                      //print(ata.id.toString());
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text('Hapus Record : '),
                                                    Text(ata.day + ' ?')
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      DbATAManager()
                                                          .deleteATA(ata.id);
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              //print(ata.id.toString());
                            },
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
