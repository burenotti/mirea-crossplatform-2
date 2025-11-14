import 'package:flutter/material.dart';
import 'package:practice2/features/screens/habbit_form_screen.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';
import 'package:practice2/features/widgets/habbits_list.dart';

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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HabbitFormScreen(habbits: controller, editingHabbitId: null),
          ),
        ),
        tooltip: 'Add habbit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
