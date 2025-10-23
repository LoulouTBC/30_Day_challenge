import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    DateTime? _rangeStart = DateTime.utc(2025, 9, 2);
    DateTime? _rangeEnd = DateTime.utc(2025, 9, 10);

    var selectedDayes = [];

    return Scaffold(
      body: TableCalendar(
        calendarFormat: _calendarFormat,
        focusedDay: _focusedDay,
        firstDay: _rangeStart,
        lastDay: _rangeEnd,
        currentDay: _focusedDay,
      ),
    );
  }
}
