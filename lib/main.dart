import 'package:flutter/material.dart';
import 'package:practice2/features/state/habbits_container.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';
import 'package:practice2/router_config.dart';

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
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: buildRouter(controller),
    );
  }
}
