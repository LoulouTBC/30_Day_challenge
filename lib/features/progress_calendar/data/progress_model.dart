class ProgressModel {
  final int progress_id;
  final int challenge_id;
  final int day_number;
  final bool status;
  final DateTime? created_at;

  ProgressModel({
    required this.progress_id,
    required this.challenge_id,
    required this.day_number,
    required this.status,
    this.created_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'progress_id': progress_id,
      'challenge_id': challenge_id,
      'day_number': day_number,
      'status': status,
      'created_at': created_at?.toIso8601String(),
    };
  }

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      progress_id: map['progress_id'],
      challenge_id: map['challenge_id'],
      day_number: map['day_number'],
      status: map['status'],
      created_at: map['created_at'] != null
          ? DateTime.parse(map['start_date'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Challenge(progress_id: $progress_id, challenge_id: $challenge_id, day_number: $day_number, created_at: $created_at)';
  }
}
