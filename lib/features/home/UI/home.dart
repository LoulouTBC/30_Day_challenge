import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> challenges = [
    {"title": "Workout Challenge"},
    {"title": "Reading Challenge"},
    {"title": "Meditation Challenge"},
    {"title": "Sleep Early Challenge"},
    {"title": "Daily Writing Challenge"},
    {"title": "Walking Challenge"},
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Challenges"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: challenges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 12, // Horizontal space between items
            mainAxisSpacing: 12, // Vertical space between items
            childAspectRatio: 1, // Width/height ratio
          ),
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${challenge["title"]}')),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade100,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),

                child:Text(
                  '$challenge["title"]',
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
        ),
      ),
    );
  }
}
