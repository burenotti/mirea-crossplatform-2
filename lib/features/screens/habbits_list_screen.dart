import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';
import 'package:practice2/features/widgets/habbits_list.dart';
import 'package:practice2/router_config.dart';

class HabbitsListScreen extends StatelessWidget {
  const HabbitsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Привычки"),
      ),
      body: ListenableBuilder(
        listenable: GetIt.I.get<HabbitsController>(),
        builder: (_, _) => HabbitsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(Routes.habbitAdd),
        tooltip: 'Add habbit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
