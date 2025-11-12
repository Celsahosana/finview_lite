import 'package:flutter/material.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinView Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData (
        colorScheme: ColorScheme.fromSeed( seedColor: Colors.teal),
        useMaterial3: true
        ),
      home: const Dashboard(),
    );
  }
}
