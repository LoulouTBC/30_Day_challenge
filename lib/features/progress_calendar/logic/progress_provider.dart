import 'package:flutter/material.dart';
import '../data/progress_model.dart';
import '../data/progress_repository.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressRepository _repo;
  ProgressProvider(this._repo);

  final Map<int, Set<DateTime>> _progressCache = {};

  Future<void> loadProgressForChallenge(int challengeId) async {
    if (_progressCache.containsKey(challengeId)) return; // use cache

    final progresses = await _repo.getCompletedDaysByChallengeId(challengeId);
    final dates = progresses
        .map((p) => _dateOnly(p.created_at ?? DateTime.now()))
        .toSet();

    _progressCache[challengeId] = dates;
    notifyListeners();
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
        rethrow;
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
        rethrow;
      }
    }
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
