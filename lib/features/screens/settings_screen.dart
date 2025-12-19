import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:practice2/features/blocs/settings/settings_bloc.dart';
import 'package:practice2/features/blocs/settings/settings_event.dart';
import 'package:practice2/features/blocs/settings/settings_state.dart';
import 'package:practice2/features/stores/settings_store.dart';
import 'package:practice2/features/widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        settingsStore: GetIt.I.get<SettingsStore>(),
      )..add(LoadSettings()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsInitial || state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                ],
              ),
            );
          }

          if (state is SettingsLoaded) {
            return ListView(
              children: [
                const SizedBox(height: 8),
                _ThemeSection(currentThemeMode: state.themeMode),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  final ThemeMode currentThemeMode;

  const _ThemeSection({required this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Тема приложения',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        _ThemeOption(
          title: 'Светлая',
          subtitle: 'Всегда использовать светлую тему',
          icon: Icons.light_mode,
          themeMode: ThemeMode.light,
          currentThemeMode: currentThemeMode,
        ),
        _ThemeOption(
          title: 'Темная',
          subtitle: 'Всегда использовать темную тему',
          icon: Icons.dark_mode,
          themeMode: ThemeMode.dark,
          currentThemeMode: currentThemeMode,
        ),
        _ThemeOption(
          title: 'Системная',
          subtitle: 'Следовать настройкам системы',
          icon: Icons.brightness_auto,
          themeMode: ThemeMode.system,
          currentThemeMode: currentThemeMode,
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode themeMode;
  final ThemeMode currentThemeMode;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeMode,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = themeMode == currentThemeMode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        context.read<SettingsBloc>().add(ChangeThemeMode(themeMode));
      },
    );
  }
}
