import 'package:flutter/material.dart';
import '../data/progress_model.dart';
import '../data/progress_repository.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressRepository _repo = ProgressRepository();

  // Cache: challengeId -> set of completed days (yyyy-MM-dd)
  final Map<int, Set<String>> _progressCache = {};
  final Map<int, bool> _isLoading = {};

  bool isLoading(int challengeId) => _isLoading[challengeId] ?? false;

  // Load progress for a challenge
  Future<void> loadProgressForChallenge(int challengeId) async {
    if (_progressCache.containsKey(challengeId)) return;
    if (_isLoading[challengeId] == true) return;

    _isLoading[challengeId] = true;
    notifyListeners();

    try {
      final progresses = await _repo.getCompletedDaysByChallengeId(challengeId);
      final dates = progresses.map((p) => p.created_at).toSet();
      _progressCache[challengeId] = dates;
    } finally {
      _isLoading[challengeId] = false;
      notifyListeners();
    }
  }

  List<String> getProgressList(int challengeId) {
    return _progressCache[challengeId]?.toList() ?? [];
  }

  double getProgressPercent(int challengeId, {int totalDays = 30}) {
    final completed = _progressCache[challengeId]?.length ?? 0;
    return (completed / totalDays).clamp(0.0, 1.0);
  }

  bool isDayDone(int challengeId, String date) {
    return _progressCache[challengeId]?.contains(date) ?? false;
  }

  // Toggle day (mark/unmark as completed)
  Future<void> toggleDay(int challengeId, String date) async {
    final set = _progressCache.putIfAbsent(challengeId, () => <String>{});
    final isDone = set.contains(date);

    if (isDone) {
      set.remove(date);
      notifyListeners();
      try {
        await _repo.removeProgressDay(challengeId, date);
      } catch (_) {
        set.add(date);
        notifyListeners();
      }
    } else {
      set.add(date);
      notifyListeners();
      try {
        await _repo.addProgressDay(
          ProgressModel(
            progress_id: 0,
            challenge_id: challengeId,
            day_number: DateTime.parse(date).day,
            status: 1,
            created_at: date,
          ),
        );
      } catch (_) {
        set.remove(date);
        notifyListeners();
      }
    }
  }
}
