import 'package:flutter/material.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitItem extends StatelessWidget {
  final Habbit habbit;
  final HabbitsController controller;

  const HabbitItem({super.key, required this.habbit, required this.controller});

  IconData _getIconData(HabbitIcon icon) {
    switch (icon) {
      case HabbitIcon.smoking:
        return Icons.smoking_rooms;
      case HabbitIcon.running:
        return Icons.directions_run;
      case HabbitIcon.reading:
        return Icons.menu_book;
      case HabbitIcon.water:
        return Icons.water_drop;
      case HabbitIcon.sport:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          controller.showHabbitStatsScreen(habbitId: habbit.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Иконка привычки
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(habbit.icon),
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              // Информация о привычке по центру
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          habbit.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Кнопка редактирования слева
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {
                            controller.showHabbitFormScreen(habbit: habbit);
                          },
                          tooltip: 'Редактировать',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Цель: ${habbit.targetDays} дней',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Прогресс: ${habbit.currentProgress} / ${habbit.targetDays}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Срывов: ${habbit.currentBreaks}',
                      style: TextStyle(fontSize: 14, color: Colors.red[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Кнопки срыва и подтверждения справа
              Column(
                children: [
                  // Кнопка срыва
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.red,
                    onPressed: habbit.isGoalReached
                        ? null
                        : () {
                            controller.breakHabbit(habbitId: habbit.id);
                          },
                    tooltip: 'Срыв',
                  ),
                  const SizedBox(height: 4),
                  // Кнопка подтверждения
                  IconButton(
                    icon: const Icon(Icons.check),
                    color: Colors.green,
                    onPressed: habbit.isGoalReached
                        ? null
                        : () {
                            controller.ackHabbit(habbitId: habbit.id);
                          },
                    tooltip: 'Подтвердить',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
