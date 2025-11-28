import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:practice2/features/bloc/habbits_form_cubit.dart';
import 'package:practice2/features/widgets/habbits_store.dart';
import 'package:practice2/router_config.dart';

class HabbitFormScreen extends StatefulWidget {
  final int? editingHabbitId;

  const HabbitFormScreen({super.key, required this.editingHabbitId});

  @override
  State<HabbitFormScreen> createState() => _HabbitFormScreenState();
}

class _HabbitFormScreenState extends State<HabbitFormScreen> {
  bool _isFormValid(HabitEditorState state) {
    return state.name.isNotEmpty &&
        state.iconUrl.isNotEmpty &&
        state.targetDays > 0;
  }

  void _submitForm(BuildContext context) async {
    final cubit = context.read<HabbitEditorCubit>();
    final router = GoRouter.of(context);

    await cubit.submit();

    if (!mounted) return;

    final state = cubit.state;
    if (state.error == null && !state.submitting) {
      router.goNamed(Routes.habbitsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I.get<HabbitsStore>();
    final editingHabbit = widget.editingHabbitId != null
        ? store.getHabbit(habbitId: widget.editingHabbitId!)
        : null;

    return BlocProvider(
      create: (context) => HabbitEditorCubit(
        store,
        habitId: widget.editingHabbitId,
        initial: editingHabbit,
      ),
      child: BlocBuilder<HabbitEditorCubit, HabitEditorState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(editingHabbit == null
                  ? "Добавление привычки"
                  : "Редактирование привычки"),
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: _isFormValid(state) ? () => _submitForm(context) : null,
                  icon: state.submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.done),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        state.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),

                  // Название привычки
                  TextField(
                    onChanged: (value) => context.read<HabbitEditorCubit>().nameChanged(value),
                    decoration: const InputDecoration(
                      labelText: 'Название привычки',
                      hintText: 'Например: Пробежка',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: state.name)
                      ..selection = TextSelection.collapsed(offset: state.name.length),
                  ),
                  const SizedBox(height: 24),

                  // URL иконки
                  TextField(
                    onChanged: (value) => context.read<HabbitEditorCubit>().iconChanged(value),
                    decoration: const InputDecoration(
                      labelText: 'URL иконки',
                      hintText: 'Например: https://example.com/icon.png',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: state.iconUrl)
                      ..selection = TextSelection.collapsed(offset: state.iconUrl.length),
                  ),
                  const SizedBox(height: 24),

                  // Целевое количество дней
                  TextField(
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null) {
                        context.read<HabbitEditorCubit>().targetChanged(parsed);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Целевое количество дней',
                      hintText: 'Например: 30',
                      border: OutlineInputBorder(),
                      suffixText: 'дней',
                    ),
                    controller: TextEditingController(text: state.targetDays.toString())
                      ..selection = TextSelection.collapsed(offset: state.targetDays.toString().length),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
