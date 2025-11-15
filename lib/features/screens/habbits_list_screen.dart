import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';
import 'package:practice2/features/widgets/habbits_list.dart';
import 'package:practice2/router_config.dart';

class HabbitsListScreen extends StatelessWidget {
  final HabbitsController controller;

  const HabbitsListScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Привычки"),
      ),
      body: HabbitsList(controller: controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(Routes.habbitAdd),
        tooltip: 'Add habbit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
