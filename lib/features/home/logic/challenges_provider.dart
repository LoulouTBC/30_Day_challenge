import 'package:challenges_app/features/home/data/challenge_model.dart';
import 'package:challenges_app/features/home/data/challenges_repository.dart';
import 'package:flutter/material.dart';

class ChallengesProvider extends ChangeNotifier {
  final ChallengesRepository _challengesRepository = ChallengesRepository();

  bool _isLoading = false;
  List<Challenge> _challenges = [];

  List<Challenge> get challenges => _challenges;
  bool get isLoading => _isLoading;

  // Fetch all challenges
  Future<void> fetchAllChallenges() async {
    _isLoading = true;
    notifyListeners();
    try {
      _challenges = await _challengesRepository.getAllChallenges();
    } catch (e) {
      print('Error fetching challenges: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Add new challenge
  Future<void> addChallenge(Challenge challenge) async {
    await _challengesRepository.insertChallenge(challenge);
    await fetchAllChallenges(); // refresh list so we don't need notifyListeners
  }

  // Delete challenge
  Future<void> deleteChallenge(int id) async {
    await _challengesRepository.deleteChallenge(id);
    await fetchAllChallenges();
  }

  /// Update existing challenge
  Future<void> updateChallenge(Challenge updatedChallenge) async {
    await _challengesRepository.updateChallenge(updatedChallenge);
    await fetchAllChallenges();
  }
}
