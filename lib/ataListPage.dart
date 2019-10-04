import 'package:ata_logger/dbmanager.dart';
import 'package:ata_logger/styles/styles.dart';
import 'package:flutter/material.dart';

class ListATAPage extends StatefulWidget {
  ListATAPage({Key key}) : super(key: key);

  _ListATAPageState createState() => _ListATAPageState();
}

class _ListATAPageState extends State<ListATAPage> {
  List<ATA> ataList;
  ATA myATA;
  bool isCompletedSwipe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'ATA RECORDS',
              style: titleText,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: DbATAManager().getATAList(),
              builder: (context, snapshot) {
                if (snapshot.hasData == null &&
                    snapshot.connectionState == ConnectionState.none) {
                  return Center(
                    child: Text('No Data'),
                  );
                }
                if (snapshot.hasData) {
                  ataList = snapshot.data;

                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(
                      thickness: 2,
                    ),
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
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
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
                                ata.clockIn,
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
                                              DbATAManager().deleteATA(ata.id);
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ));
                            },
                          ),
                        ),
                        onTap: () {
                          //print(ata.id.toString());
                        },
                      );
                    },
                  );
                }
                return Center(
                    child: Text(
                  'Belum ada Record',
                  style: titleText,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
