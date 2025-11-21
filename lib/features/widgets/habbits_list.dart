import 'package:flutter/material.dart';
import 'package:practice2/features/widgets/habbit_item.dart';
import 'package:practice2/features/widgets/habbits_provider.dart';

class HabbitsList extends StatelessWidget {
  const HabbitsList({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = context.habbitsController;

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
