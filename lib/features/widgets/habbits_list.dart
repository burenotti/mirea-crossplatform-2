import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:practice2/features/widgets/habbit_item.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitsList extends StatelessWidget {
  const HabbitsList({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = GetIt.I.get<HabbitsController>();

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
