import 'package:flutter/widgets.dart';
import 'package:practice2/features/entities/habbit.dart';

abstract interface class HabbitsController implements ChangeNotifier {
  void ackHabbit({required int habbitId});
  void breakHabbit({required int habbitId});
  void removeHabbit({required int habbitId});
  void addHabbit({
    required String name,
    required String iconUrl,
    required int targetDays,
  });
  List<Habbit> get habbits;
  void editHabbit({
    required int habbitId,
    required String name,
    required String iconUrl,
    required int targetDays,
  });
  Habbit getHabbit({required int habbitId});
}
