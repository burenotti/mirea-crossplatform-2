import 'package:practice2/features/entities/habbit.dart';

abstract interface class HabbitsController {
  void ackHabbit({required int habbitId});
  void breakHabbit({required int habbitId});
  void removeHabbit({required int habbitId});
  void addHabbit({
    required String name,
    required String iconUrl,
    required int targetDays,
  });
  List<Habbit> get habbits;
  void showHabbitFormScreen({Habbit? habbit});
  void showHabbitsListScreen();
  void showHabbitStatsScreen({required int habbitId});
  void editHabbit({
    required int habbitId,
    required String name,
    required String iconUrl,
    required int targetDays,
  });
}
