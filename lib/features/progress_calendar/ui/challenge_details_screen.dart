import 'package:challenges_app/features/progress_calendar/logic/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  const ChallengeDetailsScreen({super.key});

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  late int challengeId;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isInit = false; // guard to load once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) return;
    _isInit = true;

    // Get the challengeId from the route arguments
    challengeId = ModalRoute.of(context)!.settings.arguments as int;

    // Schedule load after current frame finishes building so notifyListeners() is safe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progressProvider = context.read<ProgressProvider>();
      progressProvider.loadProgressForChallenge(challengeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = context.watch<ProgressProvider>();
    final completedDays = progressProvider.getProgressList(challengeId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenge Progress"),
        centerTitle: true,
      ),
      body: progressProvider.isLoading(challengeId)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),

                // Calendar widget
                Expanded(
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) async {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      await progressProvider.toggleDay(challengeId, selectedDay);
                    },

                    // Customize how days are displayed
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final isCompleted = completedDays.any((d) => isSameDay(d, day));

                        if (isCompleted) {
                          return Container(
                            margin: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),

                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Progress section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Progress: ${(progressProvider.getProgressPercent(challengeId) * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressProvider.getProgressPercent(challengeId),
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                        minHeight: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
