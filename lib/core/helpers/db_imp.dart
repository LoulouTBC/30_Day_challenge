// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class FocusMeDataBase {
//   static Database? _db;

//   Future<Database?> get db async {
//     if (_db == null) {
//       _db = await initialFocusDb();
//       return _db;
//     } else {
//       return _db;
//     }
//   }

//   initialFocusDb() async {
//     print(
//       "before openDB =============================================================",
//     );
//     String databasepath = await getDatabasesPath();
//     String path = join(
//       databasepath,
//       'focusMe.db',
//     ); // join('path' ,'to','foo') => 'path/to/foo'
//     Database focusme = await openDatabase(
//       path,
//       version: 1, //when version change ,calling onupgrade
//       onCreate: _onCreateDb,
//       onUpgrade: _onUpgrade,
//     );
//     return focusme;
    
//   }

//   _onUpgrade(Database db, int oldversion, newVersion) {
//     print("onCreate =====================================");
//   }

//   _onCreateDb(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE users (
//       user_id INTEGER PRIMARY KEY AUTOINCREMENT,
//       name TEXT NOT NULL,
//       email TEXT,
//       password_hash TEXT,
//       created_at DATETIME DEFAULT CURRENT_TIMESTAMP
//     )
//   ''');

//     await db.execute('''
//     CREATE TABLE challenges (
//       challenge_id INTEGER PRIMARY KEY AUTOINCREMENT,
//       user_id INTEGER NOT NULL,
//       title TEXT NOT NULL,
//       description TEXT NOT NULL,
//       start_date DATE,
//       end_date DATE,
//       created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
//       FOREIGN KEY (user_id) REFERENCES users(user_id)
//     )
//   ''');

//     await db.execute('''
//     CREATE TABLE progress (
//       progress_id INTEGER PRIMARY KEY AUTOINCREMENT,
//       challenge_id INTEGER NOT NULL,
//       day_number INTEGER NOT NULL,
//       status TEXT CHECK(status IN ('done','not_done')) DEFAULT 'not_done',
//       created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
//       FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id)
//     )
//   ''');

//     await db.execute('''
//     CREATE TABLE achievements (
//       achievement_id INTEGER PRIMARY KEY AUTOINCREMENT,
//       user_id INTEGER NOT NULL,
//       challenge_id INTEGER NOT NULL,
//       status TEXT CHECK(status IN ('done','not_done')) DEFAULT 'not_done',
//       date DATE,
//       FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id),
//       FOREIGN KEY (user_id) REFERENCES users(user_id)
//     )
//   ''');
//     print('create database ===============================');
//   }

  // readDataFromDatabase(String sql) async {
  //   Database? mydb = await db; //check if we initial db
  //   List<Map> response = await mydb!.rawQuery(sql);
  //   return response;
  // }

  // insertDataToDatabase(String sql) async {
  //   Database? mydb = await db; //check if we initial db
  //   int response = await mydb!.rawInsert(sql);
  //   return response;
  // }

//   UpdateDataInDatabase(String sql) async {
//     Database? mydb = await db; //check if we initial db
//     int response = await mydb!.rawUpdate(sql);
//     return response;
//   }

//   DeleteDataFromDatabase(String sql) async {
//     Database? mydb = await db; //check if we initial db
//     int response = await mydb!.rawDelete(sql);
//     return response;
//   }
// }
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FocusMeDataBase {
  static Database? _db;
  static Future<Database>? _initFuture;

  static Future<Database> get db async {
    if (_db != null) return _db!;

    _initFuture ??= _initialFocusDb();
    _db = await _initFuture!;
    return _db!;
  }

  static Future<Database> _initialFocusDb() async {
    try {
      // print('before openDB =============================================================');
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'focusMe.db');

      final database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreateDb,
        onUpgrade: _onUpgrade,
      );

      // print('db opened: $path');
      return database;
    } catch (e) {
      // print('Error opening database: $e\n$st');
      rethrow;
    }
  }

  static FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // print('onUpgrade: $oldVersion -> $newVersion');
  }

  static FutureOr<void> _onCreateDb(Database db, int version) async {
    // print('onCreate called, version $version');
    await db.execute('''
      CREATE TABLE users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        password_hash TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    await db.execute('''
      CREATE TABLE challenges (
        challenge_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        start_date DATE,
        end_date DATE,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE progress (
        progress_id INTEGER PRIMARY KEY AUTOINCREMENT,
        challenge_id INTEGER NOT NULL,
        day_number INTEGER NOT NULL,
        status TEXT CHECK(status IN ('done','not_done')) DEFAULT 'not_done',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE achievements (
        achievement_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        challenge_id INTEGER NOT NULL,
        status TEXT CHECK(status IN ('done','not_done')) DEFAULT 'not_done',
        date DATE,
        FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      );
    ''');
    // print('create database ===============================');
  }

   readDataFromDatabase(String sql) async {
    Database? mydb = await db; //check if we initial db
    List<Map> response = await mydb.rawQuery(sql);
    return response;
  }

  insertDataToDatabase(String sql) async {
    Database? mydb = await db; //check if we initial db
    int response = await mydb.rawInsert(sql);
    return response;
  }

  static Future<int> updateDataInDatabase(String sql, [List<Object?>? args]) async {
    final database = await db;
    return await database.rawUpdate(sql, args);
  }

  static Future<int> deleteDataFromDatabase(String sql, [List<Object?>? args]) async {
    final database = await db;
    return await database.rawDelete(sql, args);
  }

  static Future<void> closeDb() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      _initFuture = null;
    }
  }
}
