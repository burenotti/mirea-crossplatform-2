enum ActionType {
  habbitCreated,
  habbitAcked,
  habbitDeleted,
  themeChanged,
  supportMessageSent,
}

class AppAction {
  final ActionType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  const AppAction({
    required this.type,
    required this.timestamp,
    this.data = const {},
  });
}
