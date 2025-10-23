import 'package:challenges_app/features/challenges/UI/add_new_challenge_screen.dart';
import 'package:challenges_app/features/progress_calendar/logic/progress_provider.dart';
import 'package:challenges_app/features/progress_calendar/ui/challenge_details_screen.dart';
import 'package:challenges_app/features/challenges/UI/challenges_screen.dart';
import 'package:challenges_app/features/challenges/logic/challenges_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calendar App",
      theme: ThemeData.light(),
      routes: {
        '/home': (_) => HomePage(),
        '/challengeDetailsScreen': (_) => ChallengeDetailsScreen(),
        '/addNewChallenge': (_) => AddNewChallenge(),
      },
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ChallengesProvider()..fetchAllChallenges(),
          ),
          ChangeNotifierProvider(create: (context) => ProgressProvider()),
        ],
        child: HomePage(),
      ),
    );
  }
}
