import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core/router/index_core.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage5/domain/entities/stage5_invoice_data.dart';
import 'package:core/shared/splash_screen.dart';
import 'package:core/shared/login_page.dart';
import '../feature/index_features.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = GoRouterNotifier(ref);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: notifier,
    redirect: (context, state) => authRedirect(ref, state),
    routes: [
      GoRoute(
        name: 'login',
        path: Routes.login,
        builder: (_, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'projects',
        path: Routes.projects,
        builder: (_, state) => const WebProjectSelectorPage(),
      ),
      // GoRoute(
      //   name: 'stage1',
      //   path: '${Routes.stage1}/:projectId',
      //   builder: (context, state) {
      //     final projectId = state.pathParameters['projectId']!;
      //     return WebStage1Page(projectId: projectId);
      //   },
      // ),
      GoRoute(path: Routes.splash, builder: (_, state) => const SplashScreen()),
    ],
  );
});
