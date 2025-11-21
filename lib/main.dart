import 'package:flutter/material.dart';
import 'package:practice2/features/state/habbits_container.dart';
import 'package:practice2/features/widgets/habbits_provider.dart';
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
  runApp(HabbitsProvider.wrap(controller: container, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: buildRouter(),
    );
  }
}
