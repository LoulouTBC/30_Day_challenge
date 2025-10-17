import 'package:challenges_app/core/helpers/db_imp.dart';
import 'package:challenges_app/features/progress_calendar/data/progress_model.dart';
import 'package:sqflite/sqflite.dart';

class ProgressRepository {
  // Fetch all progress records from the database.

  Future<List<ProgressModel>> getAllProgresses() async {
    final db = await FocusMeDataBase.db;
    final List<Map<String, dynamic>> maps = await db.query('progress');

    return maps.map((map) => ProgressModel.fromMap(map)).toList();
  }

  // Get progress data for a specific challenge by its ID.
  Future<ProgressModel?> getProgressByChallengeId(int challengeId) async {
    final db = await FocusMeDataBase.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'progress',
      where: 'challenge_id = ?',
      whereArgs: [challengeId],
    );

    if (maps.isNotEmpty) {
      return ProgressModel.fromMap(maps.first);
    }
    throw Exception(
      'Challenge with ID $challengeId not found in the database.',
    );
  }

  // Insert a new progress record
  Future<int> addProgressDay(ProgressModel progress) async {
    final db = await FocusMeDataBase.db;
    return await db.insert(
      'progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing progress
  Future<int> updateProgress(ProgressModel progress) async {
    final db = await FocusMeDataBase.db;

    return await db.update(
      'progress',
      progress.toMap(),
      where: 'challenge_id = ?',
      whereArgs: [progress.challenge_id],
    );
  }

  // Delete all progress records for a specific challenge.
  Future<int> deleteProgressByChallengeId(int challengeId) async {
    final db = await FocusMeDataBase.db;
    return await db.delete(
      'progress',
      where: 'challenge_id = ?',
      whereArgs: [challengeId],
    );
  }

  // Check if a specific date has already been completed for a challenge.
  Future<bool> isDayCompleted(int challengeId, String date) async {
    final db = await FocusMeDataBase.db;
    final List<Map<String, dynamic>> result = await db.query(
      'progress',
      where: 'challenge_id = ? AND date = ?',
      whereArgs: [challengeId, date],
    );
    return result.isNotEmpty;
  }

  // Get all completed days for a specific challenge.
  Future<List<ProgressModel>> getCompletedDaysByChallengeId(
    int challengeId,
  ) async {
    final db = await FocusMeDataBase.db;
    final maps = await db.query(
      'progress',
      where: 'challenge_id = ? AND completed = ?',
      whereArgs: [challengeId, 1],
    );
    return maps.map((map) => ProgressModel.fromMap(map)).toList();
  }

  // Reset all progress for a challenge back to zero.
  Future<void> resetProgress(int challengeId) async {
    final db = await FocusMeDataBase.db;
    await db.update(
      'progress',
      {'completed': 0},
      where: 'challenge_id = ?',
      whereArgs: [challengeId],
    );
  }
}
