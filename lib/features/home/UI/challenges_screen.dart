import 'package:challenges_app/features/home/data/challenges_repository.dart';
import 'package:challenges_app/features/home/logic/challenges_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final ChallengesRepository _challengesRepository = ChallengesRepository();
  // final List<Map<String, String>> challenges = [
  //   {"title": "Workout Challenge"},
  //   {"title": "Reading Challenge"},
  //   {"title": "Meditation Challenge"},
  //   {"title": "Sleep Early Challenge"},
  //   {"title": "Daily Writing Challenge"},
  //   {"title": "Walking Challenge"},
  // ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Challenges"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<ChallengesProvider>(
          builder: (context, model, child) {
            return model.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    itemCount: model.challenges.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing:
                              12, // Horizontal space between items
                          mainAxisSpacing: 12, // Vertical space between items
                          childAspectRatio: 1, // Width/height ratio
                        ),
                    itemBuilder: (context, index) {
                      final challenge = model.challenges[index];
                      return GestureDetector(
                        onTap: () async {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 19, 150, 113),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),

                          child: Text(
                            challenge.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
