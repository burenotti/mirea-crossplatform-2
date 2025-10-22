import 'package:flutter/material.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitFormScreen extends StatefulWidget {
  final HabbitsController habbits;
  final Habbit? editingHabbit;

  const HabbitFormScreen({
    super.key,
    required this.habbits,
    required this.editingHabbit,
  });

  @override
  State<HabbitFormScreen> createState() => _HabbitFormScreenState();
}

class _HabbitFormScreenState extends State<HabbitFormScreen> {
  final _nameController = TextEditingController();
  final _targetDaysController = TextEditingController();
  final Map<IconData, HabbitIcon> _icons = {
    Icons.run_circle: HabbitIcon.running,
    Icons.menu_book_sharp: HabbitIcon.reading,
    Icons.smoke_free: HabbitIcon.smoking,
    Icons.sports_basketball: HabbitIcon.sport,
    Icons.local_drink: HabbitIcon.water,
  };

  HabbitIcon? _selectedIcon;

  @override
  void dispose() {
    _nameController.dispose();
    _targetDaysController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _selectedIcon != null &&
        _targetDaysController.text.isNotEmpty &&
        int.tryParse(_targetDaysController.text) != null &&
        int.parse(_targetDaysController.text) > 0;
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.editingHabbit?.name ?? "";
    _selectedIcon = widget.editingHabbit?.icon;
    _targetDaysController.text =
        widget.editingHabbit?.targetDays.toString() ?? "";
  }

  void _submitForm() {
    if (_isFormValid) {
      if (widget.editingHabbit == null) {
        widget.habbits.addHabbit(
          name: _nameController.text,
          icon: _selectedIcon!,
          targetDays: int.parse(_targetDaysController.text),
        );
      } else {
        widget.habbits.editHabbit(
          habbitId: widget.editingHabbit!.id,
          name: _nameController.text,
          icon: _selectedIcon!,
          targetDays: int.parse(_targetDaysController.text),
        );
      }
      widget.habbits.showHabbitsListScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Добавление привычки"),
        leading: IconButton(
          onPressed: () => widget.habbits.showHabbitsListScreen(),
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
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Выбор иконки
            const Text(
              'Выберите иконку:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _icons.entries.map((entry) {
                final iconData = entry.key;
                final habbitIcon = entry.value;
                final isSelected = _selectedIcon == habbitIcon;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = habbitIcon;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      iconData,
                      size: 32,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
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
              onChanged: null,
            ),
          ],
        ),
      ),
    );
  }
}
