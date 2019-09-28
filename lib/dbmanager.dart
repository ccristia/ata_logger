import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbATAManager {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), 'ATA.db'),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE ata (id INTEGER PRIMARY KEY AUTOINCREMENT,day TEXT,clockIn TEXT,clockOut TEXT,note TEXT)');
      });
    }
  }

  Future<int> insertATA(ATA ata) async {
    await openDb();
    return await _database.insert('ata', ata.toMap());
  }

  Future<List<ATA>> getATAList() async {
    await openDb();
    final List<Map<String, dynamic>> data = await _database.query('ata');
    return List.generate(data.length, (i) {
      return ATA(
          id: data[i]['id'],
          day: data[i]['day'],
          clockIn: data[i]['clockIn'],
          clockOut: data[i]['clockOut'],
          note: data[i]['note']);
    });
  }

  Future<int> updateATA(ATA ata, String id) async {
    await openDb();

    return await _database.rawUpdate('UPDATE ata SET clockOut = "' +
        ata.clockOut +
        '" WHERE day = "' +
        id +
        '"');
  }

  Future<int> deleteATA(int id) async {
    await openDb();
    return await _database.delete('ata', where: 'id = ?', whereArgs: [id]);
  }

  Future<ATA> checkATA(String day) async {
    await openDb();

    final List<Map<String, dynamic>> data =
        await _database.rawQuery('SELECT * FROM ata WHERE day = "' + day + '"');
    if (data.isEmpty)
      return null;
    else {
      data.first;
      return ATA(
          id: data[0]['id'],
          day: data[0]['day'],
          clockIn: data[0]['clockIn'],
          clockOut: data[0]['clockOut'],
          note: data[0]['note']);
    }
  }
}

class ATA {
  int id;
  String day;
  String clockIn;
  String clockOut;
  String note;

  ATA({this.day, this.clockIn, this.clockOut, this.id, this.note});

  Map<String, dynamic> toMap() {
    return {'day': day, 'clockIn': clockIn, 'clockOut': clockOut, 'note': note};
  }
}
