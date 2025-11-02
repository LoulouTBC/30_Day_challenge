import 'package:challenges_app/core/helpers/db_imp.dart';
import 'package:flutter/material.dart';

class InsertDb extends StatelessWidget {
  InsertDb({super.key});
  final FocusMeDataBase _db = FocusMeDataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          color: Colors.amber,
          height: 200,
          child: Text('insert'),
          onPressed: () async {
            int response = await _db.insertDataToDatabase("""
                  INSERT INTO "users" ('name', 'email', 'password_hash','created_at')
                  VALUES ('John Doe', 'john@example.com', 'hashed_password_here','2024-01-04T00:00:00')
                  """);
            print(response);
            int response1 = await _db.insertDataToDatabase("""
                  INSERT INTO "challenges" ('user_id', 'title', 'description','start_date','end_date','created_at') 
                  VALUES (1, 'Challenge 1', 'description for challenge 1','2025-10-04T00:00:00','2025-11-04T00:00:00','2025-10-04T00:00:00')
                  """);
            // print(response1);
            int response2 = await _db.insertDataToDatabase("""
                  INSERT INTO "progress" ('challenge_id', 'day_number', 'status','created_at') 
                  VALUES (1, 2, 'not_done','2025-10-31T00:00:00')
                  """);
            int response3 = await _db.insertDataToDatabase("""
                  INSERT INTO progress (challenge_id, day_number, status)
                  VALUES (1, 3, 1);
                  """);
            int response4 = await _db.insertDataToDatabase("""
                  INSERT INTO progress (challenge_id, day_number, status)
                  VALUES (1, 5, 1);
                  """);
            print('respons2= $response2');
            print('respons3= $response3');
            print('respons4= $response4');
            print(await _db.readDataFromDatabase('SELECT * FROM challenges'));
          },
        ),
      ),
    );
  }
}
