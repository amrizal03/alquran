import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  DatabaseManager._private();

  static DatabaseManager instance = DatabaseManager._private();

  Database? _db;

  Future<Database?> get db async {
    if(_db == null) {
      _db = await _initDB();
    }
    return _db;
  }

  Future _initDB() async {
    Directory docDir = await getApplicationCacheDirectory();

    String path = join(docDir.path,"bookmarg.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        return await database.execute(
          '''
            CREATE TABLE bookmark (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              surah TEXT NOT NULL,
              ayat INTEGER NOT NULL,
              juz INTEGER NOT NULL,
              via TEXT NOT NULL,
              index_ayat TEXT NOT_NULL,
              last_read INTEGER DEFAULT 0
            )
          '''
        );
      },
    );
  }

  Future closeDB() async {
    _db = await instance.db;
    _db?.close();
  }

}