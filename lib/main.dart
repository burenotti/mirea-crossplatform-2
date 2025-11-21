import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:practice2/features/state/habbits_container.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';
import 'package:practice2/router_config.dart';

void main() {
  GetIt.I.registerSingleton<HabbitIdGenerator>(() {
    var current = 0;
    return () {
      current += 1;
      return current;
    };
  }());
  GetIt.I.registerSingleton<CurrentDateTimeProvider>(() => DateTime.now());

  GetIt.I.registerLazySingleton<HabbitsController>(
    () => HabbitsContainer(
      currentDateTime: GetIt.I.get<CurrentDateTimeProvider>(),
      nextHabbitId: GetIt.I.get<HabbitIdGenerator>(),
    ),
  );
  runApp(MyApp());
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
