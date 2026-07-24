import 'package:ai_first_flutter_starter/app/config/environment_provider.dart';
import 'package:ai_first_flutter_starter/app/router/app_routes.dart';
import 'package:ai_first_flutter_starter/app/router/guards/authentication_guard.dart';
import 'package:ai_first_flutter_starter/app/router/route_paths.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/controllers/login_controller.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/pages/login_page.dart';
import 'package:ai_first_flutter_starter/features/home/presentation/pages/home_page.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final class RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = RouterRefreshNotifier();
  final enableLogging = ref.watch(appConfigProvider).enableLogging;

  ref
    ..listen(loginControllerProvider, (_, _) => refreshNotifier.refresh())
    ..onDispose(refreshNotifier.dispose);

  final router = GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: enableLogging,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      return const AuthenticationGuard().redirect(
        isAuthenticated: ref.read(loginControllerProvider).user != null,
        location: state.uri.path,
      );
    },
    routes: [
      GoRoute(
        name: AppRoutes.login.name,
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoutes.home.name,
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: AppErrorView(
          title: 'Page not found',
          message: 'No route is registered for ${state.uri.path}.',
          actionLabel: 'Return to start',
          onAction: () => context.go(RoutePaths.home),
        ),
      );
    },
  );

  ref.onDispose(router.dispose);
  return router;
});
