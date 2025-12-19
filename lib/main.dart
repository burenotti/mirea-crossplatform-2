import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:practice2/features/blocs/articles/articles_bloc.dart';
import 'package:practice2/features/blocs/articles/articles_event.dart';
import 'package:practice2/features/stores/articles_store.dart';
import 'package:practice2/features/stores/articles_store_impl.dart';
import 'package:practice2/features/stores/auth_store.dart';
import 'package:practice2/features/stores/auth_store_impl.dart';
import 'package:practice2/features/stores/habbits_store.dart';
import 'package:practice2/features/widgets/habbits_store.dart';
import 'package:practice2/router_config.dart';

void main() {
  GetIt.I.registerSingleton<HabbitIdGenerator>(() {
    var current = 0;
    return () {
      current += 1;
      return current;
    };
  }());
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticlesBloc(
        articlesStore: GetIt.I.get<ArticlesStore>(),
      )..add(LoadArticles()),
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: buildRouter(),
      ),
    );
  }
}
