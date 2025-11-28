import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:practice2/features/bloc/habbits_list/habbits_bloc.dart';
import 'package:practice2/features/widgets/habbits_store.dart';
import 'package:practice2/features/widgets/habbits_list.dart';
import 'package:practice2/router_config.dart';

class HabbitsListScreen extends StatelessWidget {
  const HabbitsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HabbitsBloc(habbitsStore: GetIt.I.get<HabbitsStore>()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Привычки"),
        ),
        body: HabbitsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.pushNamed(Routes.habbitAdd),
          tooltip: 'Add habbit',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
