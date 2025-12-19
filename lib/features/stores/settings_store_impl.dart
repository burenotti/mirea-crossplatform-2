import 'dart:async';
import 'package:flutter/material.dart';
import 'package:practice2/features/entities/app_action.dart';
import 'package:practice2/features/entities/app_settings.dart';
import 'package:practice2/features/stores/actions_store.dart';
import 'package:practice2/features/stores/settings_store.dart';

class SettingsStoreImpl implements SettingsStore {
  final ActionsStore actionsStore;
  AppSettings _settings = const AppSettings(themeMode: ThemeMode.system);
  final _controller = StreamController<AppSettings>.broadcast();

  SettingsStoreImpl({required this.actionsStore});

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

    // Отправляем событие об изменении темы
    actionsStore.dispatch(AppAction(
      type: ActionType.themeChanged,
      timestamp: DateTime.now(),
      data: {'themeMode': themeMode.toString()},
    ));
  }

  void dispose() {
    _controller.close();
  }
}
