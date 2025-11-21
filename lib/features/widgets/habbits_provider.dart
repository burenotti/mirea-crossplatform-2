import 'package:flutter/material.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitsProvider extends InheritedWidget {
  final HabbitsController habbitsController;

  const HabbitsProvider({
    super.key,
    required this.habbitsController,
    required super.child,
  });

  static HabbitsProvider of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<HabbitsProvider>();
    assert(provider != null, "HabbitsProvider is not found in build context");
    return provider!;
  }

  @override
  bool updateShouldNotify(HabbitsProvider oldWidget) => true;

  static Widget wrap({
    required HabbitsController controller,
    required Widget child,
  }) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return HabbitsProvider(habbitsController: controller, child: child!);
      },
      child: child,
    );
  }
}

extension HabbitsProviderX on BuildContext {
  HabbitsController get habbitsController =>
      HabbitsProvider.of(this).habbitsController;
}
