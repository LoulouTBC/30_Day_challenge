// import 'package:challenges_app/core/helpers/db_imp.dart';

// class ChallengesRepository {
//   final FocusMeDataBase _db = FocusMeDataBase();

//   /// get all challenges
//   Future<List<Map<String, dynamic>>> getAllChallenges() async {
//     final db = await FocusMeDataBase.db;
//     return await db.query('challenges');
//   }

//   /// insert a new challenge
//   Future<int> addChallenge({
//     required int userId,
//     required String title,
//     required String description,
//   }) async {
//     final db = await FocusMeDataBase.db;
//     return await db.insert('challenges', {
//       'user_id': userId,
//       'title': title,
//       'description': description,
//       'start_date': DateTime.now().toIso8601String(),
//     });
//   }

//   /// update challenge
//   Future<int> updateChallenge({
//     required int id,
//     required String newTitle,
//   }) async {
//     final db = await FocusMeDataBase.db;
//     return await db.update(
//       'challenges',
//       {'title': newTitle},
//       where: 'challenge_id = ?',
//       whereArgs: [id],
//     );
//   }

//   /// delete challenge
//   Future<int> deleteChallenge(int id) async {
//     final db = await FocusMeDataBase.db;
//     return await db.delete(
//       'challenges',
//       where: 'challenge_id = ?',
//       whereArgs: [id],
//     );
//   }
// }
import 'package:challenges_app/core/helpers/db_imp.dart';
import 'package:challenges_app/features/home/data/challenge_model.dart';
import 'package:sqflite/sqflite.dart';

class ChallengesRepository {
  final FocusMeDataBase _db = FocusMeDataBase();

  /// 🔹 إرجاع كل التحديات
  Future<List<Challenge>> getAllChallenges() async {
    final db = await FocusMeDataBase.db;
    final List<Map<String, dynamic>> maps = await db.query('challenges');

    return maps.map((map) => Challenge.fromMap(map)).toList();
  }

  /// 🔹 إضافة تحدٍ جديد
  Future<int> insertChallenge(Challenge challenge) async {
    final db = await FocusMeDataBase.db;
    return await db.insert(
      'challenges',
      challenge.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 🔹 تحديث تحدٍ
  Future<int> updateChallenge(Challenge challenge) async {
    final db = await FocusMeDataBase.db;
    return await db.update(
      'challenges',
      challenge.toMap(),
      where: 'challenge_id = ?',
      whereArgs: [challenge.challengeId],
    );
  }

  /// 🔹 حذف تحدٍ
  Future<int> deleteChallenge(int id) async {
    final db = await FocusMeDataBase.db;
    return await db.delete(
      'challenges',
      where: 'challenge_id = ?',
      whereArgs: [id],
    );
  }

  /// 🔹 جلب تحدٍ محدد عبر الـ id
  Future<Challenge?> getChallengeById(int id) async {
    final db = await FocusMeDataBase.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'challenges',
      where: 'challenge_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Challenge.fromMap(maps.first);
    }
    return null;
  }
}
