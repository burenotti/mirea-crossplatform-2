import 'package:flutter/material.dart';

abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class ChangeThemeMode extends SettingsEvent {
  final ThemeMode themeMode;

  ChangeThemeMode(this.themeMode);
}

class SettingsUpdated extends SettingsEvent {
  final ThemeMode themeMode;

  SettingsUpdated(this.themeMode);
}
