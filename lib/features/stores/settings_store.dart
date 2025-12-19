import 'package:flutter/material.dart';
import 'package:practice2/features/entities/app_settings.dart';

abstract class SettingsStore {
  AppSettings getSettings();
  Stream<AppSettings> watchSettings();
  void updateThemeMode(ThemeMode themeMode);
}
