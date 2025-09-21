// import 'dart:async'; //because we need loading
// import 'package:flutter/widgets.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

class Challenges {
  final int challenge_id;
  final String title;
  final String description;
  final DateTime start_date;
  final DateTime end_date;
  final int is_active;
  final DateTime created_at;

  Challenges({
    required this.challenge_id,
    required this.title,
    required this.description,
    required this.start_date,
    required this.end_date,
    required this.is_active,
    required this.created_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'challenge_id': challenge_id,
      'title': title,
      'description': description,
      'start_date': start_date,
      'end_date': end_date,
      'is_active': is_active,
      'created_at': created_at,
    };
  }

  @override
  String toString() {
    return 'challenges { challenge_id:$challenge_id, title:$title, description:$description, start_date:$start_date,end_date:$end_date,is_active:$is_active,created_at:$created_at }';
  }
}
