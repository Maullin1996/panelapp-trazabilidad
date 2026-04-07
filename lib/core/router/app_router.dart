import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/index_core.dart';

import 'package:registro_panela/features/index_features.dart';
import 'package:registro_panela/features/project_selector/presentation/project_selector_page.dart';
import 'package:registro_panela/features/pdf/presentation/pdf_screen.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';

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
        pageBuilder: (_, state) => noTransitionPage(const LoginPage(), state),
      ),
      GoRoute(
        name: 'projects',
        path: Routes.projects,
        pageBuilder: (_, state) => fadePage(const ProjectSelectorPage(), state),
        routes: [
          GoRoute(
            name: 'stageSelector',
            path: '${Routes.stages}/:projectId',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return StageSelectorPage(projectId: projectId);
            },
          ),
        ],
      ),
      GoRoute(
        name: 'stage1',
        path: '${Routes.stage1}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return Stage1Page(projectId: projectId);
        },
      ),
      GoRoute(
        name: 'stage2Detail',
        path: '${Routes.stage2}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return Stage2Page(projectId: projectId);
        },
      ),
      GoRoute(
        name: 'stage3Detail',
        path: '${Routes.stage3}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return Stage3Page(projectId: projectId);
        },
        routes: [
          GoRoute(
            name: 'stage3Form',
            path: ':load2Id/form',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final load2Id = state.pathParameters['load2Id']!;
              return Stage3FormPage(projectId: projectId, load2Id: load2Id);
            },
          ),
          GoRoute(
            name: 'stage3Summary',
            path: ':load2Id/summary',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final load2Id = state.pathParameters['load2Id']!;
              return Stage3PageSummary(load2Id: load2Id, projectId: projectId);
            },
          ),
        ],
      ),

      GoRoute(
        name: 'stage4Detail',
        path: '${Routes.stage4}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return Stage4Page(projectId: projectId);
        },
      ),
      GoRoute(
        name: 'stage5page',
        path: '${Routes.stage5}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return Stage5Page(projectId: projectId);
        },
        routes: [
          GoRoute(
            name: 'stage5summary',
            path: 'summary',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return Stage5Summary(projectId: projectId);
            },
          ),
          GoRoute(
            name: 'stage5report',
            path: 'report',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return Stage5MissingWeight(projectId: projectId);
            },
          ),
          GoRoute(
            name: 'stage5records',
            path: 'records',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return Stage52Page(projectId: projectId);
            },
            routes: [
              GoRoute(
                name: 'stage52form',
                path: 'form',
                builder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  return Stage52FormPage(projectId: projectId);
                },
              ),
              GoRoute(
                name: 'stage52edit',
                path: ':id/edit',
                builder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  final id = state.pathParameters['id'];
                  return Stage52FormPage(projectId: projectId, id: id);
                },
              ),
              GoRoute(
                name: 'stage52summary',
                path: ':recordId/summary',
                builder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  final recordId = state.pathParameters['recordId']!;
                  return Stage52SummaryPage(
                    projectId: projectId,
                    recordId: recordId,
                  );
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: Routes.splash,
        pageBuilder: (_, state) =>
            noTransitionPage(const SplashScreen(), state),
      ),
      GoRoute(
        path: Routes.imageViewer,
        builder: (_, state) {
          final String image = state.extra as String;
          return ImageViewer(image: image);
        },
      ),
      GoRoute(
        name: 'pdf-preview',
        path: '/pdf-preview',
        builder: (_, state) {
          final project = state.extra as Stage1FormData;
          return PdfScreen(project: project);
        },
      ),
      GoRoute(
        name: 'adminResetPassword',
        path: '/admin/reset-password',
        builder: (_, _) => const AdminResetPasswordPage(),
      ),
    ],
  );
});
