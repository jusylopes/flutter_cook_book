import 'package:flutter/foundation.dart';
import 'package:flutter_cook_book/data/services/auth_service.dart';
import 'package:flutter_cook_book/di/service_locator.dart';
import 'package:flutter_cook_book/ui/auth/auth_view.dart';
import 'package:flutter_cook_book/ui/base_screen.dart';
import 'package:flutter_cook_book/ui/fav_recipes/fav_recipes_view.dart';
import 'package:flutter_cook_book/ui/profile/profile_view.dart';
import 'package:flutter_cook_book/ui/recipe_detail/recipe_detail_view.dart';
import 'package:flutter_cook_book/ui/recipes/recipes_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router;

  final _service = getIt<AuthService>();

  late final ValueNotifier<bool> _authStateNotifier;

  AppRouter() {
    _authStateNotifier = ValueNotifier<bool>(_service.currentUser != null);

    _service.authStateChanges.listen((state) async {
      _authStateNotifier.value = _service.currentUser != null;
    });

    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _authStateNotifier,
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const AuthView()),
        ShellRoute(
          builder: (context, state, child) => BaseScreen(child: child),
          routes: [
            GoRoute(path: '/', builder: (context, state) => RecipesView()),
            GoRoute(
              path: '/recipe/:id',
              builder:
                  (context, state) =>
                      RecipeDetailView(id: state.pathParameters['id']!),
            ),
            GoRoute(
              path: '/favorites',
              builder: (context, state) => FavRecipesView(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileView(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = _authStateNotifier.value;
        final currentPath = state.uri.path;

        if (!isLoggedIn && currentPath != '/login') {
          return '/login';
        }

        if (isLoggedIn && currentPath == '/login') {
          return '/';
        }

        return null;
      },
    );
  }
}
