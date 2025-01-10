import 'package:flutter/material.dart';
import 'package:trials_phone_app/Pages/home.dart';
import 'package:trials_phone_app/Pages/results_page.dart';
import 'package:flutter/foundation.dart';

void main() {
  debugPrint = (String? message, {int? wrapWidth}) {
    if (kDebugMode) {
      print(message);
    }
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/results': (context) => ResultsPage(submittedResults: []),  // This remains the same
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/results') {
          final List<Map<String, dynamic>> results = settings.arguments as List<Map<String, dynamic>>;
          return MaterialPageRoute(
            builder: (context) => ResultsPage(submittedResults: results),
          );
        }
        return null;
      },
    );
  }
}