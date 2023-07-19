import 'dart:io';
import 'dart:isolate';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbRestore {
  late RxBool progress = false.obs;
  List<Map> data = [];
  static var databaseFactory = databaseFactoryFfi;

  readDbFile(String dbName) async {
    data.clear();
    final receivePort = ReceivePort();
    Database? db = await databaseFactory.openDatabase(dbName);
    List<Map> response = await db.rawQuery(
        "SELECT day, receive_n, item, price, remark, level, picture_a, picture_b, picture_c FROM repair");
    if (response.isNotEmpty) {
      data.addAll(response);
      await Isolate.spawn(restore, [receivePort.sendPort, data]);

      receivePort.listen((sum) {
        if (sum == false) {
          progress.value = false;
        }
      });
    }
    return db;
  }

  static void restore(List<dynamic> args) async {
    var sendPort = args[0] as SendPort;
    String? userHome =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    databaseFactory.setDatabasesPath('$userHome/workshop databases/');
    List<Map> data = args[1];
    if (data.isNotEmpty) {
      for (var element in data) {
        List date = element['day'].split('-');
        Database? db = await databaseFactory.openDatabase('${date[0]}.db',
            options: OpenDatabaseOptions(
              onConfigure: _onCreate,
            ));
        await db.insert("repair", {
          'day': element['day'],
          'receive_n': element['receive_n'],
          'item': '${element['item']}',
          'price': element['price'],
          'remark': '${element['remark']}',
          'level': element['level'],
          'picture_a': '${element['picture_a']}',
          'picture_b': '${element['picture_b']}',
          'picture_c': '${element['picture_c']}'
        });
        await db.close();
      }
    }
    sendPort.send(false);
    Isolate.exit(sendPort, args);
  }

  static void _onCreate(Database db) async {
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
}
