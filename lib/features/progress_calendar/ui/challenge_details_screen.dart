import 'package:challenges_app/features/progress_calendar/logic/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final int challengeId;

  const ChallengeDetailsScreen({super.key, required this.challengeId});

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isInit = false;

  late int challengeId;

  String formatDate(DateTime date) =>
      "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";

  @override
  void initState() {
    super.initState();
    challengeId = widget.challengeId;
    
    Future.microtask(() {
      Provider.of<ProgressProvider>(
        context,
        listen: false,
      ).loadProgressForChallenge(challengeId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) return;
    _isInit = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progressProvider = context.read<ProgressProvider>();
      progressProvider.loadProgressForChallenge(challengeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = context.watch<ProgressProvider>();
    final completedDays = progressProvider.getProgressList(
      challengeId,
    ); // List<String> yyyy-MM-dd

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
                Expanded(
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        _selectedDay != null && day == _selectedDay,
                    onDaySelected: (selectedDay, focusedDay) async {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });

                      //update date in yyyy-mm-dd
                      await progressProvider.toggleDay(
                        challengeId,
                        formatDate(selectedDay),
                      );
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final isCompleted = completedDays.contains(
                          formatDate(day),
                        );

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
