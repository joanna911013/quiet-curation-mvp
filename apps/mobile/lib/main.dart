import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/today_screen.dart';
import 'screens/emotion_screen.dart';
import 'screens/done_screen.dart';

void main() {
  runApp(const QuietCurationApp());
}

class QuietCurationApp extends StatelessWidget {
  const QuietCurationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiet Curation',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/today': (context) => const TodayScreen(),
        '/emotion': (context) => const EmotionScreen(),
        '/done': (context) => const DoneScreen(),
      },
    );
  }
}
