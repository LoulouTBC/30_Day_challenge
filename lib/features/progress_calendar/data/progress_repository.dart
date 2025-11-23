import 'package:challenges_app/core/helpers/db_imp.dart';
import 'package:challenges_app/features/progress_calendar/data/progress_model.dart';
import 'package:sqflite/sqflite.dart';

class ProgressRepository {
  // Fetch all progress records
  Future<List<ProgressModel>> getAllProgresses() async {
    final db = await FocusMeDataBase.db;
    final List<Map<String, dynamic>> maps = await db.query('progress');
    return maps.map((map) => ProgressModel.fromMap(map)).toList();
  }

  // Get all progress entries for a specific challenge
  Future<List<ProgressModel>> getCompletedDaysByChallengeId(int challengeId) async {
    final db = await FocusMeDataBase.db;
    final maps = await db.query(
      'progress',
      where: 'challenge_id = ? AND status = ?',
      whereArgs: [challengeId, 1],
    );
    return maps.map((map) => ProgressModel.fromMap(map)).toList();
  }

  // Add a new progress record
  Future<int> addProgressDay(ProgressModel progress) async {
    final db = await FocusMeDataBase.db;
    return await db.insert(
      'progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove a specific progress day
  Future<int> removeProgressDay(int challengeId, String date) async {
    final db = await FocusMeDataBase.db;
    return await db.delete(
      'progress',
      where: 'challenge_id = ? AND created_at = ?',
      whereArgs: [challengeId, date],
    );
  }

  // Reset all progress (mark as incomplete)
  Future<void> resetProgress(int challengeId) async {
    final db = await FocusMeDataBase.db;
    await db.update(
      'progress',
      {'status': 0},
      where: 'challenge_id = ?',
      whereArgs: [challengeId],
    );
  }
}
