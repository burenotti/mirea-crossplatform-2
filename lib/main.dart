import 'package:flutter/material.dart';
import 'package:practice2/features/screens/habbits_list_screen.dart';
import 'package:practice2/features/state/habbits_container.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

void main() {
  var container = HabbitsContainer(
    currentDateTime: () => DateTime.now(),
    nextHabbitId: () {
      var current = 0;
      return () {
        current += 1;
        return current;
      };
    }(),
  );
  runApp(MyApp(controller: container));
}

class MyApp extends StatelessWidget {
  final HabbitsController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: HabbitsListScreen(controller: controller),
    );
  }
}
