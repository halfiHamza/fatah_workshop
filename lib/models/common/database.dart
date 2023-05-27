import 'dart:io';

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqlDb {
  static Database? _db;
  static String? _dbName;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      // fakeData();
      return _db;
    } else {
      return _db;
    }
  }

  Future<String> get dbName async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    var dbPref = sharedPref.getString("_databaseName");
    _dbName = dbPref != null
        ? dbPref.toString()
        : '${DateTime.now().year.toString()}.db';
    return _dbName.toString();
  }

  String? get userHome =>
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  initDb() async {
    String? myDbName = await dbName;
    var databaseFactory = databaseFactoryFfi;
    databaseFactory.setDatabasesPath('$userHome/workshop databases/');
    Database localdb = await databaseFactory.openDatabase(myDbName,
        options: OpenDatabaseOptions(
          singleInstance: false,
          readOnly: false,
          onConfigure: _onCreate,
        ));
    return localdb;
  }

  _onCreate(Database db) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS `repair` (
            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
            `day` DATE,
            `receive_n` INTEGER,
            `item` TEXT VARCHAR(255),
            `price` REAL,
            `remark` TEXT VARCHAR(255),
            `level` INTEGER DEFAULT 0,
            `picture_a` TEXT,
            `picture_b` TEXT,
            `picture_c` TEXT)
          ''');
  }

  insertData(
      {required String table, required Map<String, Object?> data}) async {
    Database? myDb = await db;
    int response = await myDb!.insert(table, data);
    return response;
  }

  Future<int> deleteData(
      {required String table, required int id, required String colId}) async {
    Database? myDb = await db;
    int response =
        await myDb!.delete(table, where: '$colId = ?', whereArgs: [id]);
    return response;
  }

  updateData(
      {required String table,
      required String colId,
      required int id,
      required Map<String, Object?> data}) async {
    Database? myDb = await db;
    int response =
        await myDb!.update(table, data, where: "$colId = ?", whereArgs: [id]);
    return response;
  }

  getPictures(
      {required String table, required String colId, required int id}) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.query(table,
        columns: ['picture_a, picture_b, picture_c'],
        where: '$colId = ?',
        whereArgs: [id]);
    return response;
  }

  readData(
      {required String table,
      required List<String> column,
      required String order}) async {
    Database? myDb = await db;
    var response = await myDb!.query(table, columns: column, orderBy: order);
    return response;
  }

  executeQuery({required String query}) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(query);
    return response;
  }

  fakeData() async {
    Database? myDb = await db;
    final startDate = DateTime(2023, 1, 1);
    final endDate = DateTime(2023, 8, 30);

    final random = Random();
    // final laptops = <String, List<Map<String, dynamic>>>{};

    for (var date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      // final laptopList = <Map<String, dynamic>>[];
      for (var i = 0; i < 3; i++) {
        final brand = _getRandomBrand(random);
        final receiveN = random.nextInt(9999);
        myDb!.rawInsert(
            "INSERT INTO repair(day, receive_n, item, price, level) VALUES('${DateFormat('y-MM-dd').format(date)}', '$receiveN','$brand', '${randomChoice([
              6000.00,
              7000.00,
              8000.00,
              10000.00,
              15000.00,
              20000.00,
              22000.00
            ])}', ${randomChoice([0, 1, 2])})");
        myDb.batch();
        // laptopList.add({'item': brand, 'price': price});
      }

      // laptops[date.toIso8601String()] = laptopList;
    }

    // final jsonEncoded = json.encode({'laptops': laptops});
  }

  String _getRandomBrand(Random random) {
    final brands = [
      'Dell latitude d600',
      'Lenovo think pad t440',
      'Acer aspire e1-350',
      'HP pavilion',
      'Asus rog strix',
      'Apple macbook air',
      'Toshiba satellite',
      'Samsung galaxy book',
      'Huawei mate book a16'
    ];
    return randomChoice(brands);
  }
}
