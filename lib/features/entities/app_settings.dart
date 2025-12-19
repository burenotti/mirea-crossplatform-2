import 'package:flutter/material.dart';

class AppSettings {
  final ThemeMode themeMode;

  const AppSettings({
    required this.themeMode,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
