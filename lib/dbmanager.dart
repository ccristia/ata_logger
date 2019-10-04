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
        await db.execute('''
        CREATE TABLE profile (
          id INTEGER PRIMARY KEY,
          nama TEXT,
          foto TEXT,
          warna INTEGER)
        ''');
        await db.execute('''
        CREATE TABLE clockIn (
          id INTEGER PRIMARY KEY,
          jam INTEGER,
          menit INTEGER,
          detik INTEGER,
          judul_notifikasi_ClockIn TEXT,
          body_notifikasi_ClockIn TEXT)
        ''');
        await db.execute('''
        CREATE TABLE clockOut (
          id INTEGER PRIMARY KEY,
          jam INTEGER,
          menit INTEGER,
          detik INTEGER,
          judul_notifikasi_ClockOut TEXT,
          body_notifikasi_ClockOut TEXT)
        ''');
        await db.execute("INSERT INTO profile VALUES (0,'Little Giant','',0)");
        await db.execute(
            "INSERT INTO clockIn VALUES (0,7,30,0,'Mase','Sudah Clock In kah? Jangan Lupa Ya.')");
        await db.execute(
            "INSERT INTO clockOut VALUES (0,15,30,0,'Mase','Sudah Clock Out kah? Jangan Lupa Ya.')");
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

  Future<List<ClockIn>> getClockIn() async {
    await openDb();
    final List<Map<String, dynamic>> data = await _database.query('clockIn');
    return List.generate(data.length, (i) {
      return ClockIn(
        id: data[i]['id'],
        jam: data[i]['jam'],
        menit: data[i]['menit'],
        detik: data[i]['detik'],
        judulClockIn: data[i]['judul_notifikasi_ClockIn'],
        bodyClockIn: data[i]['body_notifikasi_ClockIn'],
      );
    });
  }

  Future<List<ClockOut>> getClockOut() async {
    await openDb();
    final List<Map<String, dynamic>> data = await _database.query('clockOut');
    return List.generate(data.length, (i) {
      return ClockOut(
        id: data[i]['id'],
        jam: data[i]['jam'],
        menit: data[i]['menit'],
        detik: data[i]['detik'],
        judulClockOut: data[i]['judul_notifikasi_ClockOut'],
        bodyClockOut: data[i]['body_notifikasi_ClockOut'],
      );
    });
  }

  Future<List<Profile>> getProfile() async {
    await openDb();
    final List<Map<String, dynamic>> data = await _database.query('profile');
    return List.generate(data.length, (i) {
      return Profile(
        id: data[i]['id'],
        nama: data[i]['nama'],
        foto: data[i]['foto'],
        warna: data[i]['warna'],
      );
    });
  }

  Future<int> deleteATA(int id) async {
    await openDb();
    return await _database.delete('ata', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateATA(ATA ata, String id) async {
    await openDb();

    return await _database.rawUpdate('UPDATE ata SET clockOut = "' +
        ata.clockOut +
        '" WHERE day = "' +
        id +
        '"');
  }

  Future<int> updateALL(
      {ClockIn clockIn, ClockOut clockOut, Profile profile}) async {
    await openDb();
    await _database.rawUpdate('''
    UPDATE clockIn SET jam = ${clockIn.jam} , menit = ${clockIn.menit} , detik = ${clockIn.detik},
    judul_notifikasi_ClockIn = "${clockIn.judulClockIn}" , body_notifikasi_ClockIn = "${clockIn.bodyClockIn}"
    WHERE  id = 0
    ''');

    await _database.rawUpdate('''
    UPDATE clockOut SET jam = ${clockOut.jam} , menit = ${clockOut.menit} , detik = ${clockOut.detik},
    judul_notifikasi_ClockOut = "${clockOut.judulClockOut}" , body_notifikasi_ClockOut = "${clockOut.bodyClockOut}"
    WHERE  id = 0
    ''');

    await _database.rawUpdate('''
    UPDATE profile SET nama = "${profile.nama}" , foto = ${profile.foto}, warna = ${profile.warna}
    WHERE  id = 0
    ''');

    return 1;
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

  Future<List<ATA>> getATA(String day) async {
    await openDb();
    var data =
        await _database.rawQuery('SELECT * FROM ata WHERE day = "' + day + '"');
    if (data.isEmpty)
      return null;
    else {
      return List.generate(data.length, (i) {
        return ATA(
            id: data[i]['id'],
            day: data[i]['day'],
            clockIn: data[i]['clockIn'],
            clockOut: data[i]['clockOut'],
            note: data[i]['note']);
      });
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

class ClockIn {
  int id;
  int jam;
  int menit;
  int detik;
  String judulClockIn;
  String bodyClockIn;

  ClockIn(
      {this.id,
      this.jam,
      this.menit,
      this.detik,
      this.judulClockIn,
      this.bodyClockIn});

  Map<String, dynamic> toMap() {
    return {
      'jam': jam,
      'menit': menit,
      'detik': detik,
      'judul': judulClockIn,
      'body': bodyClockIn
    };
  }
}

class ClockOut {
  int id;
  int jam;
  int menit;
  int detik;
  String judulClockOut;
  String bodyClockOut;

  ClockOut(
      {this.id,
      this.jam,
      this.menit,
      this.detik,
      this.judulClockOut,
      this.bodyClockOut});

  Map<String, dynamic> toMap() {
    return {
      'jam': jam,
      'menit': menit,
      'detik': detik,
      'judul': judulClockOut,
      'body': bodyClockOut
    };
  }
}

class Profile {
  int id;
  String nama;
  String foto;
  int warna;

  Profile({this.id, this.nama, this.foto, this.warna});

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'foto': foto,
      'warna': warna,
    };
  }
}
