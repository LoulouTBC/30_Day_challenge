import 'package:challenges_app/core/helpers/db_imp.dart';
import 'package:challenges_app/features/home/data/challenge_model.dart';
import 'package:sqflite/sqflite.dart';

class ChallengesRepository {

  /// return all challenges
  Future<List<Challenge>> getAllChallenges() async {
    final db = await FocusMeDataBase.db;
    final List<Map<String, dynamic>> maps = await db.query('challenges');

    return maps.map((map) => Challenge.fromMap(map)).toList();
  }

  /// add new challenge
  Future<int> insertChallenge(Challenge challenge) async {
    final db = await FocusMeDataBase.db;
    return await db.insert(
      'challenges',
      challenge.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// update challenge
  Future<int> updateChallenge(Challenge challenge) async {
    final db = await FocusMeDataBase.db;
    return await db.update(
      'challenges',
      challenge.toMap(),
      where: 'challenge_id = ?',
      whereArgs: [challenge.challengeId],
    );
  }

  /// delete challenge
  Future<int> deleteChallenge(int id) async {
    final db = await FocusMeDataBase.db;
    return await db.delete(
      'challenges',
      where: 'challenge_id = ?',
      whereArgs: [id],
    );
  }

  /// get a specific challenge by id
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
     throw Exception('Challenge with ID $id not found in the database.');
  }
}
