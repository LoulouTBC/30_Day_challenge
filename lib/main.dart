import 'package:challenges_app/core/helpers/inserting_schema.dart';
import 'package:challenges_app/features/home/UI/challenges_screen.dart';
import 'package:challenges_app/features/home/logic/challenges_provider.dart';
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
      routes: {'/home': (_) => HomePage()},
      home: ChangeNotifierProvider(
        create: (context) => ChallengesProvider()..fetchAllChallenges(),
        child: HomePage(),
      ),
    );
  }
}
