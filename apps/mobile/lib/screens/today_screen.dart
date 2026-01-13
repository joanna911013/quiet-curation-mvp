import 'package:flutter/material.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Reading")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              'Literature\n\n'
              '"Even the darkest night will end, and the sun will rise."\n'
              '— Victor Hugo',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              'Scripture\n\n'
              'Psalm 30:5\n"Weeping may endure for a night, '
              'but joy comes in the morning."',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/emotion');
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
