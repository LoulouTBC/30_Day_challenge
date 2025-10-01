import 'package:challenges_app/core/helpers/db_imp.dart';
import 'package:challenges_app/features/progress_calendar/ui/progress_calendar_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FocusMeDataBase database = FocusMeDataBase();
  // await database.db;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calendar App",
      theme: ThemeData.light(),
      // home: GlobalCalendar(),
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  FocusMeDataBase sqldb = FocusMeDataBase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 192, 19, 19), // لون خلفية جديد
                  foregroundColor: Colors.white, // لون النص
                  minimumSize: Size(200, 100), // الحجم
                ),
                onPressed: () async {
                  int response = await sqldb.insertDataToDatabase("""
                INSERT INTO "users" ('name', 'email', 'password_hash') 
                VALUES ('John Doe', 'john@example.com', 'hashed_password_here')
                """);
                  print(response);
                },
                child: Center(child: Text("Insert Data")),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // لون خلفية جديد
                  foregroundColor: Colors.white, // لون النص
                  minimumSize: Size(200, 100), // الحجم
                ),
                onPressed: () async {
                  List<Map> response = await sqldb.readDataFromDatabase("""
                  SELECT * FROM users
                  """);
                  print(response);
                },
                child: Center(child: Text("Read Data")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
