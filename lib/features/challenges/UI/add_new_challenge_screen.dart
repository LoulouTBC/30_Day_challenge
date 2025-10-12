import 'package:challenges_app/features/challenges/data/challenge_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:challenges_app/features/challenges/logic/challenges_provider.dart';

class AddNewChallenge extends StatelessWidget {
  const AddNewChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> keyFormStata = GlobalKey();
    String challengeTitle ='';
    int userId = 0;
    String describtion ='';
    DateTime? firstDay;
    DateTime? lastDay;

    

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          children: [
            SizedBox(height: 200),
            Text('add new challenge'),
            Consumer<ChallengesProvider>(
              builder: (context, model, child) {
                return Form(
                  key: keyFormStata,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (newValue) {
                          userId = int.parse(newValue!);
                        },
                        decoration: InputDecoration(hint: Text('user id')),
                      ),
                      TextFormField(
                        onSaved: (newValue) {
                          challengeTitle = newValue!;
                        },
                        decoration: InputDecoration(
                          hint: Text('challenge title'),
                        ),
                      ),
                      TextFormField(
                        onSaved: (newValue) {
                          describtion = newValue!;
                        },
                        decoration: InputDecoration(hint: Text('describtion')),
                      ),
                      SizedBox(height: 20),
                      InputDatePickerFormField(
                        onDateSaved: (newValue) {
                          firstDay = newValue;
                        },
                        firstDate: DateTime.utc(2018 - 1 - 1),
                        lastDate: DateTime.utc(2045 - 1 - 1),
                      ),
                      SizedBox(height: 20),
                      InputDatePickerFormField(
                        onDateSaved: (newValue) {
                          firstDay = newValue;
                        },
                        firstDate: DateTime.utc(2018 - 1 - 1),
                        lastDate: DateTime.utc(2045 - 1 - 1),
                      ),
                      MaterialButton(
                        child: const Text('Add Challenge'),
                        onPressed: () {
                          keyFormStata.currentState!.save();

                          final newChallenge = Challenge(
                            userId: userId,
                            title: challengeTitle,
                            description: describtion,
                            startDate: firstDay,
                            endDate: lastDay,
                          );

                          model.addChallenge(newChallenge);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
