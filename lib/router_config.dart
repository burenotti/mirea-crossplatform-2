import 'package:go_router/go_router.dart';
import 'package:practice2/features/screens/habbit_form_screen.dart';
import 'package:practice2/features/screens/habbit_stats_screen.dart';
import 'package:practice2/features/screens/habbits_list_screen.dart';

final class Routes {
  static const habbitsList = 'habbitsList';
  static const habbitAdd = 'habbitAdd';
  static const habbitStats = 'habbitStats';
  static const habbitEdit = 'habbitEdit';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/habbits'),
      GoRoute(
        path: '/habbits',
        name: Routes.habbitsList,
        builder: (context, state) => HabbitsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: Routes.habbitAdd,
            builder: (context, state) =>
                HabbitFormScreen(editingHabbitId: null),
          ),
          GoRoute(
            path: ':id/stats',
            name: Routes.habbitStats,
            builder: (context, state) => HabbitStatsScreen(
              habbitId: int.parse(state.pathParameters["id"]!),
            ),
          ),
          GoRoute(
            path: ':id/edit',
            name: Routes.habbitEdit,
            builder: (context, state) => HabbitFormScreen(
              editingHabbitId: int.parse(state.pathParameters["id"]!),
            ),
          ),
        ],
      ),
    ],
  );
}
