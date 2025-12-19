import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:practice2/features/blocs/settings/settings_event.dart';
import 'package:practice2/features/blocs/settings/settings_state.dart';
import 'package:practice2/features/stores/settings_store.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsStore settingsStore;
  StreamSubscription? _settingsSubscription;

  SettingsBloc({required this.settingsStore}) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<SettingsUpdated>(_onSettingsUpdated);

    _settingsSubscription = settingsStore.watchSettings().listen((settings) {
      add(SettingsUpdated(settings.themeMode));
    });
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    emit(SettingsLoading());

    try {
      final settings = settingsStore.getSettings();
      emit(SettingsLoaded(themeMode: settings.themeMode));
    } catch (e) {
      emit(SettingsError('Не удалось загрузить настройки'));
    }
  }

  void _onChangeThemeMode(ChangeThemeMode event, Emitter<SettingsState> emit) {
    try {
      settingsStore.updateThemeMode(event.themeMode);
    } catch (e) {
      emit(SettingsError('Не удалось изменить тему'));
    }
  }

  void _onSettingsUpdated(SettingsUpdated event, Emitter<SettingsState> emit) {
    emit(SettingsLoaded(themeMode: event.themeMode));
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
