import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:practice2/features/blocs/articles/articles_bloc.dart';
import 'package:practice2/features/blocs/articles/articles_event.dart';
import 'package:practice2/features/blocs/settings/settings_bloc.dart';
import 'package:practice2/features/blocs/settings/settings_event.dart';
import 'package:practice2/features/blocs/settings/settings_state.dart';
import 'package:practice2/features/stores/articles_store.dart';
import 'package:practice2/features/stores/articles_store_impl.dart';
import 'package:practice2/features/stores/auth_store.dart';
import 'package:practice2/features/stores/auth_store_impl.dart';
import 'package:practice2/features/stores/faq_store.dart';
import 'package:practice2/features/stores/faq_store_impl.dart';
import 'package:practice2/features/stores/habbits_store.dart';
import 'package:practice2/features/stores/settings_store.dart';
import 'package:practice2/features/stores/settings_store_impl.dart';
import 'package:practice2/features/stores/support_store.dart';
import 'package:practice2/features/stores/support_store_impl.dart';
import 'package:practice2/features/widgets/habbits_store.dart';
import 'package:practice2/router_config.dart';

void main() {
  // Регистрируем генератор ID для Habbits
  GetIt.I.registerSingleton<HabbitIdGenerator>(() {
    var current = 0;
    return () {
      current += 1;
      return current;
    };
  }());

  // Регистрируем генератор ID для Messages с именем
  GetIt.I.registerSingleton<MessageIdGenerator>(
    () {
      var current = 0;
      return () {
        current += 1;
        return current;
      };
    }(),
    instanceName: 'messageIdGenerator',
  );

  GetIt.I.registerSingleton<CurrentDateTimeProvider>(() => DateTime.now());

  GetIt.I.registerLazySingleton<AuthStore>(
    () => AuthStoreImpl(),
  );

  GetIt.I.registerLazySingleton<HabbitsStore>(
    () => HabbitsStoreImpl(
      currentDateTime: GetIt.I.get<CurrentDateTimeProvider>(),
      nextHabbitId: GetIt.I.get<HabbitIdGenerator>(),
    ),
  );

  GetIt.I.registerLazySingleton<ArticlesStore>(
    () => ArticlesStoreImpl(),
  );

  GetIt.I.registerLazySingleton<SupportStore>(
    () => SupportStoreImpl(
      nextMessageId: GetIt.I.get<MessageIdGenerator>(instanceName: 'messageIdGenerator'),
      currentDateTime: GetIt.I.get<CurrentDateTimeProvider>(),
    ),
  );

  GetIt.I.registerLazySingleton<FaqStore>(
    () => FaqStoreImpl(),
  );

  GetIt.I.registerLazySingleton<SettingsStore>(
    () => SettingsStoreImpl(),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticlesBloc(
            articlesStore: GetIt.I.get<ArticlesStore>(),
          )..add(LoadArticles()),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(
            settingsStore: GetIt.I.get<SettingsStore>(),
          )..add(LoadSettings()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final themeMode = state is SettingsLoaded ? state.themeMode : ThemeMode.system;

          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: buildRouter(),
          );
        },
      ),
    );
  }
}
