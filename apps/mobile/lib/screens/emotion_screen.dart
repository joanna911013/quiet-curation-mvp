import 'package:flutter/material.dart';

class EmotionScreen extends StatefulWidget {
  const EmotionScreen({super.key});

  @override
  State<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  String? selectedEmotion;

  final emotions = const [
    'Peace',
    'Anxiety',
    'Gratitude',
    'Grief',
    'Hope',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How do you feel?')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: emotions.map((emotion) {
                return ChoiceChip(
                  label: Text(emotion),
                  selected: selectedEmotion == emotion,
                  onSelected: (_) {
                    setState(() => selectedEmotion = emotion);
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: selectedEmotion == null
                  ? null
                  : () {
                      Navigator.pushNamed(context, '/done');
                    },
              child: const Text('Save'),
            ),

          ],
        ),
      ),
    );
  }
}
