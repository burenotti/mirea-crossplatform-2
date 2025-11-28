import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice2/features/bloc/habbits_list/habbits_bloc.dart';
import 'package:practice2/features/bloc/habbits_list/habbits_state.dart';
import 'package:practice2/features/widgets/habbit_item.dart';

class HabbitsList extends StatelessWidget {
  const HabbitsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabbitsBloc, HabbitsState>(
      builder: (context, state) => ListView.builder(
        itemCount: state.habbits.length,
        itemBuilder: (context, index) => HabbitItem(
          habbit: state.habbits[index],
          key: ValueKey(state.habbits[index].id),
        ),
      ),
    );
  }
}
