import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitItem extends StatelessWidget {
  final Habbit habbit;
  final HabbitsController controller;

  const HabbitItem({super.key, required this.habbit, required this.controller});

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
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: habbit.iconUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
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
                        Expanded(
                          child: Text(
                            habbit.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Прогресс: ${habbit.currentProgress} / ${habbit.targetDays}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Срывов: ${habbit.currentBreaks}',
                      style: TextStyle(fontSize: 14, color: Colors.red[700]),
                      overflow: TextOverflow.ellipsis,
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
