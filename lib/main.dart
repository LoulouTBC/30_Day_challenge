import 'package:challenges_app/features/progress_calendar/ui/progress_calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'better_life.db'),
    onCreate: (db, version) async => await db.execute(
      "CREATE TABLE challenges (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT, start_date DATETIME ,end_date DATETIME, is_active INTEGER ,created_at DATETIME DEFAULT CURRENT_TIMESTAMP )",
    ),
    version: 1,
  );
  final db = await database;
  final tables = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='challenges'",
  );

  if (tables.isNotEmpty) {
    print("✅ Table 'challenges' exists!");
  } else {
    print("❌ Table 'challenges' does NOT exist.");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calendar App",
      theme: ThemeData.light(),
      home: GlobalCalendar(),
    );
  }
}
