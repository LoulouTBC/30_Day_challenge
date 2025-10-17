class Challenge {
  final int? challengeId;
  final int userId;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;

  Challenge({
    this.challengeId,
    required this.userId,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'challenge_id': challengeId,
      'user_id': userId,
      'title': title,
      'description': description,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      challengeId: map['challenge_id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      startDate: map['start_date'] != null
          ? DateTime.parse(map['start_date'])
          : null,
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Challenge(challengeId: $challengeId, userId: $userId, title: $title, description: $description)';
  }
}
