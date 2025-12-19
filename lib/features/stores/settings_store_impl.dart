import 'dart:async';
import 'package:flutter/material.dart';
import 'package:practice2/features/entities/app_settings.dart';
import 'package:practice2/features/stores/settings_store.dart';

class SettingsStoreImpl implements SettingsStore {
  AppSettings _settings = const AppSettings(themeMode: ThemeMode.system);
  final _controller = StreamController<AppSettings>.broadcast();

  @override
  AppSettings getSettings() {
    return _settings;
  }

  @override
  Stream<AppSettings> watchSettings() {
    return _controller.stream;
  }

  @override
  void updateThemeMode(ThemeMode themeMode) {
    _settings = _settings.copyWith(themeMode: themeMode);
    _controller.add(_settings);
  }

  void dispose() {
    _controller.close();
  }
}
