import 'package:go_router/go_router.dart';
import 'package:practice2/features/screens/habbit_form_screen.dart';
import 'package:practice2/features/screens/habbit_stats_screen.dart';
import 'package:practice2/features/screens/habbits_list_screen.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

final class Routes {
  static const habbitsList = 'habbitsList';
  static const habbitAdd = 'habbitAdd';
  static const habbitStats = 'habbitStats';
  static const habbitEdit = 'habbitEdit';
}

GoRouter buildRouter(HabbitsController controller) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/habbits',
      ),
      GoRoute(
        path: '/habbits',
        name: Routes.habbitsList,
        builder: (context, state) => HabbitsListScreen(controller: controller),
        routes: [
          GoRoute(
            path: 'add',
            name: Routes.habbitAdd,
            builder: (context, state) =>
                HabbitFormScreen(habbits: controller, editingHabbitId: null),
          ),
          GoRoute(
            path: ':id/stats',
            name: Routes.habbitStats,
            builder: (context, state) => HabbitStatsScreen(
              controller: controller,
              habbitId: int.parse(state.pathParameters["id"]!),
            ),
          ),
          GoRoute(
            path: ':id/edit',
            name: Routes.habbitEdit,
            builder: (context, state) => HabbitFormScreen(
              habbits: controller,
              editingHabbitId: int.parse(state.pathParameters["id"]!),
            ),
          ),
        ],
      ),
    ],
  );
}
