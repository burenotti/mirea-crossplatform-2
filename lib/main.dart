import 'package:flutter/material.dart';
import 'screens/MainScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Практическая работа №3',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Mainscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
