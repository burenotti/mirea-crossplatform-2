import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:practice2/features/screens/auth/sign_in_screen.dart';
import 'package:practice2/features/screens/auth/sign_up_screen.dart';
import 'package:practice2/features/screens/habbit_form_screen.dart';
import 'package:practice2/features/screens/habbit_stats_screen.dart';
import 'package:practice2/features/screens/habbits_list_screen.dart';
import 'package:practice2/features/screens/profile_screen.dart';
import 'package:practice2/features/screens/articles/articles_list_screen.dart';
import 'package:practice2/features/stores/auth_store.dart';

final class Routes {
  static const signIn = 'signIn';
  static const signUp = 'signUp';
  static const profile = 'profile';
  static const habbitsList = 'habbitsList';
  static const habbitAdd = 'habbitAdd';
  static const habbitStats = 'habbitStats';
  static const habbitEdit = 'habbitEdit';
  static const articlesList = 'articlesList';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authStore = GetIt.I.get<AuthStore>();
      final isAuthenticated = authStore.currentUser != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      // If not authenticated and trying to access protected routes, redirect to sign in
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/sign-in';
      }

      // If authenticated and trying to access auth routes, redirect to habbits
      if (isAuthenticated && isAuthRoute) {
        return '/habbits';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/habbits'),
      GoRoute(
        path: '/auth/sign-in',
        name: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/auth/sign-up',
        name: Routes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
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
      GoRoute(
        path: '/articles',
        name: Routes.articlesList,
        builder: (context, state) => const ArticlesListScreen(),
      ),
    ],
  );
}
