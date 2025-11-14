import 'package:flutter/material.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/screens/habbit_form_screen.dart';
import 'package:practice2/features/screens/habbit_stats_screen.dart';
import 'package:practice2/features/screens/habbits_list_screen.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

enum Screen { HabbitsList, HabbitForm, HabbitStats }

class HabbitsContainer extends StatefulWidget {
  const HabbitsContainer({
    super.key,
    required this.currentDateTime,
    required this.nextHabbitId,
  });

  final DateTime Function() currentDateTime;
  final int Function() nextHabbitId;

  @override
  State<HabbitsContainer> createState() => _HabbitsContainerState();
}

class _HabbitsContainerState extends State<HabbitsContainer>
    implements HabbitsController {
  List<Habbit> _habbits = [];

  Screen _currentScreen = Screen.HabbitsList;
  int? _selectedHabbitId;

  @override
  void addHabbit({
    required String name,
    required String iconUrl,
    required int targetDays,
  }) {
    setState(() {
      _habbits.add(
        Habbit(
          id: widget.nextHabbitId(),
          name: name,
          createdAt: widget.currentDateTime(),
          iconUrl: iconUrl,
          targetDays: targetDays,
        ),
      );
    });
  }

  @override
  void ackHabbit({required int habbitId}) {
    setState(() {
      _exchange(
        habbitId: habbitId,
        mutation: (h) => h.withAck(widget.currentDateTime()),
      );
    });
  }

  @override
  void breakHabbit({required int habbitId}) {
    setState(() {
      _exchange(
        habbitId: habbitId,
        mutation: (h) => h.withBreak(widget.currentDateTime()),
      );
    });
  }

  @override
  void removeHabbit({required int habbitId}) {
    setState(() {
      _habbits = _habbits.where((h) => h.id != habbitId).toList();
    });
  }

  void _exchange({
    required int habbitId,
    required Habbit Function(Habbit) mutation,
  }) {
    var index = _habbits.indexWhere((h) => h.id == habbitId);
    _habbits[index] = mutation(_habbits[index]);
  }

  @override
  List<Habbit> get habbits => List.unmodifiable(_habbits);

  @override
  Widget build(BuildContext context) {
    final habbit = _habbits.where((h) => h.id == _selectedHabbitId).firstOrNull;
    switch (_currentScreen) {
      case Screen.HabbitsList:
        return HabbitsListScreen(controller: this);
      case Screen.HabbitForm:
        return HabbitFormScreen(habbits: this, editingHabbit: habbit);
      case Screen.HabbitStats:
        return HabbitStatsScreen(habbit: habbit!, controller: this);
    }
  }

  @override
  void showHabbitFormScreen({Habbit? habbit}) {
    setState(() {
      _selectedHabbitId = habbit?.id;
      _currentScreen = Screen.HabbitForm;
    });
  }

  @override
  void showHabbitsListScreen() {
    setState(() {
      _currentScreen = Screen.HabbitsList;
      _selectedHabbitId = null;
    });
  }

  @override
  void showHabbitStatsScreen({required int habbitId}) {
    setState(() {
      _currentScreen = Screen.HabbitStats;
      _selectedHabbitId = habbitId;
    });
  }

  @override
  void editHabbit({
    required int habbitId,
    required String name,
    required String iconUrl,
    required int targetDays,
  }) {
    _exchange(
      habbitId: habbitId,
      mutation: (h) =>
          h.withName(name).withTargetDays(targetDays).withIconUrl(iconUrl),
    );
  }
}
