import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FocusMeDataBase {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialFocusDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialFocusDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(
      databasepath,
      'focusMe.db',
    ); // join('path' ,'to','foo') => 'path/to/foo'
    Database focusme = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb,
    );
    return focusme;
  }

  _onCreateDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT,
      password_hash TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
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
    )
  ''');

    await db.execute('''
    CREATE TABLE progress (
      progress_id INTEGER PRIMARY KEY AUTOINCREMENT,
      challenge_id INTEGER NOT NULL,
      day_number INTEGER NOT NULL,
      status TEXT CHECK(status IN ('done','not_done')) DEFAULT 'not_done',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id)
    )
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
    )
  ''');
    print('create database');
  }
}
