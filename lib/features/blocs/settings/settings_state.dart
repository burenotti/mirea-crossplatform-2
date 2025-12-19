import 'package:flutter/material.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final ThemeMode themeMode;

  SettingsLoaded({required this.themeMode});
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}
