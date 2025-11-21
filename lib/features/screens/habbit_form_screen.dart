import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';
import 'package:practice2/router_config.dart';

class HabbitFormScreen extends StatefulWidget {
  final int? editingHabbitId;

  const HabbitFormScreen({super.key, required this.editingHabbitId});

  @override
  State<HabbitFormScreen> createState() => _HabbitFormScreenState();
}

class _HabbitFormScreenState extends State<HabbitFormScreen> {
  final _nameController = TextEditingController();
  final _targetDaysController = TextEditingController();
  final _iconUrlController = TextEditingController();
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _targetDaysController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _iconUrlController.text.isNotEmpty &&
        _targetDaysController.text.isNotEmpty &&
        int.tryParse(_targetDaysController.text) != null &&
        int.parse(_targetDaysController.text) > 0;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateFormState);
    _iconUrlController.addListener(_updateFormState);
    _targetDaysController.addListener(_updateFormState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      final editingHabbit = _editingHabbit;
      _nameController.text = editingHabbit?.name ?? "";
      _iconUrlController.text = editingHabbit?.iconUrl ?? "";
      _targetDaysController.text = editingHabbit?.targetDays.toString() ?? "";
    }
  }

  Habbit? get _editingHabbit => widget.editingHabbitId == null
      ? null
      : GetIt.I.get<HabbitsController>().getHabbit(
          habbitId: widget.editingHabbitId!,
        );

  void _updateFormState() {
    setState(() {});
  }

  void _submitForm() {
    if (_isFormValid) {
      if (_editingHabbit == null) {
        GetIt.I.get<HabbitsController>().addHabbit(
          name: _nameController.text,
          iconUrl: _iconUrlController.text,
          targetDays: int.parse(_targetDaysController.text),
        );
      } else {
        GetIt.I.get<HabbitsController>().editHabbit(
          habbitId: _editingHabbit!.id,
          name: _nameController.text,
          iconUrl: _iconUrlController.text,
          targetDays: int.parse(_targetDaysController.text),
        );
      }
      context.goNamed(Routes.habbitsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Добавление привычки"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _isFormValid ? _submitForm : null,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название привычки
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название привычки',
                hintText: 'Например: Пробежка',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // URL иконки
            TextField(
              controller: _iconUrlController,
              decoration: const InputDecoration(
                labelText: 'URL иконки',
                hintText: 'Например: https://example.com/icon.png',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Целевое количество дней
            TextField(
              controller: _targetDaysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Целевое количество дней',
                hintText: 'Например: 30',
                border: OutlineInputBorder(),
                suffixText: 'дней',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
