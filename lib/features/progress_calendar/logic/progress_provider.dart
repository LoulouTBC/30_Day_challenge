import 'package:flutter/material.dart';
import '../data/progress_model.dart';
import '../data/progress_repository.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressRepository _repo = ProgressRepository();

  // cache: challengeId -> set of completed days
  final Map<int, Set<DateTime>> _progressCache = {};

  // Loading state per challenge
  final Map<int, bool> _isLoading = {};

  bool isLoading(int challengeId) => _isLoading[challengeId] ?? false;

  /// Load progress for a specific challenge
  Future<void> loadProgressForChallenge(int challengeId) async {
    // If data already loaded, skip fetching again (avoid unnecessary notify)
    if (_progressCache.containsKey(challengeId)) return;

    // Avoid multiple calls for the same challenge (race condition guard)
    if (_isLoading[challengeId] == true) return;

    _isLoading[challengeId] = true;
    notifyListeners(); // safe if we call this after build (we will)

    try {
      final progresses = await _repo.getCompletedDaysByChallengeId(challengeId);
      final dates = progresses
          .map((p) => _dateOnly(p.created_at ?? DateTime.now()))
          .toSet();

      _progressCache[challengeId] = dates;
    } finally {
      _isLoading[challengeId] = false;
      notifyListeners(); // update UI when loading finishes
    }
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  List<DateTime> getProgressList(int challengeId) {
    final set = _progressCache[challengeId];
    if (set == null) return [];
    final list = set.toList()..sort();
    return list;
  }

  bool isDayDone(int challengeId, DateTime day) {
    final d = _dateOnly(day);
    final set = _progressCache[challengeId];
    return set?.any((s) => isSameDay(s, d)) ?? false;
  }

  double getProgressPercent(int challengeId, {int totalDays = 30}) {
    final completed = _progressCache[challengeId]?.length ?? 0;
    return (completed / totalDays).clamp(0.0, 1.0);
  }

  Future<void> toggleDay(int challengeId, DateTime day) async {
    final d = _dateOnly(day);
    final set = _progressCache.putIfAbsent(challengeId, () => <DateTime>{});
    final currentlyDone = set.any((s) => isSameDay(s, d));

    if (currentlyDone) {
      set.removeWhere((s) => isSameDay(s, d));
      notifyListeners();
      try {
        await _repo.removeProgressDay(challengeId, d);
      } catch (e) {
        set.add(d);
        notifyListeners();
      }
    } else {
      set.add(d);
      notifyListeners();
      try {
        await _repo.addProgressDay(
          ProgressModel(
            progress_id: 0,
            challenge_id: challengeId,
            day_number: d.day,
            status: true,
            created_at: d,
          ),
        );
      } catch (e) {
        set.removeWhere((s) => isSameDay(s, d));
        notifyListeners();
      }
    }
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
