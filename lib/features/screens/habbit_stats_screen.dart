import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitStatsScreen extends StatelessWidget {
  final int habbitId;

  const HabbitStatsScreen({super.key, required this.habbitId});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    var habbit = GetIt.I.get<HabbitsController>().getHabbit(habbitId: habbitId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика привычки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о привычке
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habbit.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Цель',
                          '${habbit.targetDays} дней',
                          Icons.flag,
                          Colors.blue,
                        ),
                        _buildStatItem(
                          'Прогресс',
                          '${habbit.currentProgress}',
                          Icons.trending_up,
                          Colors.green,
                        ),
                        _buildStatItem(
                          'Подтверждений',
                          '${habbit.currentAcks}',
                          Icons.check_circle,
                          Colors.green,
                        ),
                        _buildStatItem(
                          'Срывов',
                          '${habbit.currentBreaks}',
                          Icons.cancel,
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: habbit.targetDays > 0
                          ? (habbit.currentProgress / habbit.targetDays).clamp(
                              0.0,
                              1.0,
                            )
                          : 0.0,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        habbit.isGoalReached ? Colors.green : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      habbit.isGoalReached
                          ? 'Цель достигнута!'
                          : '${((habbit.currentProgress / habbit.targetDays) * 100).toStringAsFixed(1)}% выполнено',
                      style: TextStyle(
                        color: habbit.isGoalReached
                            ? Colors.green
                            : Colors.grey[600],
                        fontWeight: habbit.isGoalReached
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Заголовок списка событий
            const Text(
              'История событий',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Список событий
            Expanded(
              child: habbit.events.isEmpty
                  ? Center(
                      child: Text(
                        'Пока нет событий',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: habbit.events.length,
                      itemBuilder: (context, index) {
                        final event =
                            habbit.events[habbit.events.length - 1 - index];
                        final isAck = event is Ack;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              isAck ? Icons.check_circle : Icons.cancel,
                              color: isAck ? Colors.green : Colors.red,
                              size: 32,
                            ),
                            title: Text(
                              isAck ? 'Подтверждение' : 'Срыв',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isAck
                                    ? Colors.green[700]
                                    : Colors.red[700],
                              ),
                            ),
                            subtitle: Text(
                              _formatDate(event.occuredOn),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
