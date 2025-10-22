import 'package:flutter/material.dart';
import 'package:practice2/features/widgets/habbit_item.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitsList extends StatelessWidget {
  final HabbitsController controller;

  const HabbitsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.habbits.length,
      itemBuilder: (context, index) => HabbitItem(
        habbit: controller.habbits[index],
        controller: controller,
        key: ValueKey(controller.habbits[index].id),
      ),
    );
  }
}
