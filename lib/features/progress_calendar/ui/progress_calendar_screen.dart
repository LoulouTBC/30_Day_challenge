import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class GlobalCalendar extends StatefulWidget {
  const GlobalCalendar({super.key});

  @override
  State<GlobalCalendar> createState() => _GlobalCalendarState();
}

class _GlobalCalendarState extends State<GlobalCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart = DateTime.utc(2025, 9, 2);
  DateTime? _rangeEnd = DateTime.utc(2025, 9, 10);

  var selectedDayes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Container(color: Colors.red, height: 100, width: 100),
      body: Column(
        children: [
          SizedBox(height: 200),
          TableCalendar(
            // rangeSelectionMode: RangeSelectionMode.toggledOn,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            onRangeSelected: (start, end, focusedDay) => {
              setState(() {
                _rangeStart = start ?? _rangeStart;
                _rangeEnd = end ?? _rangeEnd;
                _focusedDay = focusedDay;
              }),
            },
            // selectedDayPredicate: (day) {
            //   // Use `selectedDayPredicate` to determine which day is currently selected.
            //   // If this returns true, then `day` will be marked as selected.

            //   // Using `isSameDay` is recommended to disregard
            //   // the time-part of compared DateTime objects.
            //   return isSameDay(_selectedDay, day);
            // },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
               setState(() {
                // If no range exists, start a new range
                if (_rangeStart == null) {
                  _rangeStart = selectedDay;
                  _rangeEnd = selectedDay;
                } else {
                  // If selected day is before the current start, update start
                  if (selectedDay.isBefore(_rangeStart!)) {
                    _rangeStart = selectedDay;
                  } else {
                    // If selected day is after current end, extend the range
                    if (_rangeEnd == null || selectedDay.isAfter(_rangeEnd!)) {
                      _rangeEnd = selectedDay;
                    }
                  }
                }

                // Update focused day to selected day
                _focusedDay = focusedDay;
              });
              // setState(() {
              //   if (_rangeStart == null || _rangeEnd != null) {
              //     // new Range 
              //     _rangeStart = selectedDay;
              //     _rangeEnd = null;
              //   } else {
              
              //     if (selectedDay.isBefore(_rangeStart!)) {
              //       _rangeStart = selectedDay; 
              //     } else {
              //       _rangeEnd = selectedDay; 
              //     }
              //   }
              //   _focusedDay = focusedDay;
              // });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}
