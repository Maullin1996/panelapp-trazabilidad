import 'package:core/features/stage5/domain/entities/stage5_invoice_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core/router/index_core.dart';
import 'package:core/shared/splash_screen.dart';
import 'package:core/shared/login_page.dart';
import 'package:core/shared/stage5_invoice_summary_page.dart';
import '../feature/index_features.dart';
import 'package:core/shared/stage_selector_page.dart';
import 'package:core/shared/administrative_page.dart';
import 'package:core/shared/image_viewer.dart';
import 'package:core/shared/pdf_screen.dart';
import 'package:core/features/stage1_delivery/domain/entities/index.dart';

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
      GoRoute(
        name: 'stage1',
        path: '${Routes.stage1}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return WebStage1Page(projectId: projectId);
        },
      ),
      GoRoute(
        name: 'stage2Detail',
        path: '${Routes.stage2}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return WebStage2Page(projectId: projectId);
        },
      ),
      GoRoute(
        name: 'stage3Detail',
        path: '${Routes.stage3}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return WebStage3Page(projectId: projectId);
        },
        routes: [
          GoRoute(
            name: 'stage3Form',
            path: ':load2Id/form',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final load2Id = state.pathParameters['load2Id']!;
              return WebStage3FormPage(projectId: projectId, load2Id: load2Id);
            },
          ),
          GoRoute(
            name: 'stage3Summary',
            path: ':load2Id/summary',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final load2Id = state.pathParameters['load2Id']!;
              return WebStage3SummaryPage(
                load2Id: load2Id,
                projectId: projectId,
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'stage4Detail',
        path: '${Routes.stage4}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return WebStage4Page(projectId: projectId);
        },
      ),
      GoRoute(
        name: 'stage5page',
        path: '${Routes.stage5}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return WebStage5Page(projectId: projectId);
        },
        routes: [
          GoRoute(
            name: 'stage5summary',
            path: 'summary',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return WebStage5Page(projectId: projectId);
            },
          ),
          GoRoute(
            name: 'stage5report',
            path: 'report',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return WebStage5Page(projectId: projectId);
            },
          ),
          GoRoute(
            name: 'stage5records',
            path: 'records',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return WebStage5Page(projectId: projectId);
            },
            routes: [
              GoRoute(
                name: 'stage52form',
                path: 'form',
                builder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  return WebStage52FormPage(projectId: projectId);
                },
              ),
              GoRoute(
                name: 'stage52edit',
                path: ':id/edit',
                builder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  final id = state.pathParameters['id'];
                  return WebStage52FormPage(projectId: projectId, id: id);
                },
              ),
              GoRoute(
                name: 'stage52summary',
                path: ':recordId/summary',
                builder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  final recordId = state.pathParameters['recordId']!;
                  return WebStage52SummaryPage(
                    projectId: projectId,
                    recordId: recordId,
                  );
                },
              ),
              GoRoute(
                name: 'stage5invoice',
                path: 'invoice',
                builder: (context, state) {
                  final invoice = state.extra as Stage5InvoiceData;
                  return Stage5InvoiceSummaryPage(invoice: invoice);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: 'stageSelector',
        path: '${Routes.projects}${Routes.stages}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return StageSelectorPage(projectId: projectId);
        },
      ),
      GoRoute(
        name: 'adminResetPassword',
        path: '/admin/reset-password',
        builder: (_, _) => const AdminResetPasswordPage(),
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
      GoRoute(path: Routes.splash, builder: (_, state) => const SplashScreen()),
    ],
  );
});
