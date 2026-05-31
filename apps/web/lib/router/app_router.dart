import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage5/domain/entities/stage5_invoice_data.dart';
import 'package:core/shared/utils/tokens.dart';

import 'package:core/shared/stage52_form_page.dart';
import 'package:core/shared/stage_selector_page.dart';
import 'package:core/shared/administrative_page.dart';
import 'package:core/shared/image_viewer.dart';
import 'package:core/shared/pdf_screen.dart';
import 'package:core/shared/splash_screen.dart';
import 'package:core/shared/login_page.dart';
import 'package:core/shared/stage5_invoice_summary_page.dart';
import 'package:core/core/router/index_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../feature/index_features.dart';
import 'transitions.dart';
import 'package:core/shared/stage52_page_summary.dart';
import '../feature/project_selector/mobile_project_selector_page.dart'
    as mobile;

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
        pageBuilder: (_, state) => fadePage(
          AdaptiveLayout(
            mobile: const mobile.ProjectSelectorPage(),
            web: const WebProjectSelectorPage(),
          ),
          state,
        ),
        routes: [
          GoRoute(
            name: 'stageSelector',
            path: '${Routes.stages}/:projectId',
            pageBuilder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return slideUpPage(
                StageSelectorPage(projectId: projectId),
                state,
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'stage1',
        path: '${Routes.stage1}/:projectId',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return slideUpPage(
            AdaptiveLayout(
              mobile: Stage1Page(projectId: projectId),
              web: WebStage1Page(projectId: projectId),
            ),
            state,
          );
        },
      ),
      GoRoute(
        name: 'stage2Detail',
        path: '${Routes.stage2}/:projectId',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return slideUpPage(
            AdaptiveLayout(
              mobile: Stage2Page(projectId: projectId),
              web: WebStage2Page(projectId: projectId),
            ),
            state,
          );
        },
      ),
      GoRoute(
        name: 'stage3Detail',
        path: '${Routes.stage3}/:projectId',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return slideUpPage(
            AdaptiveLayout(
              mobile: Stage3Page(projectId: projectId),
              web: WebStage3Page(projectId: projectId),
            ),
            state,
          );
        },
        routes: [
          GoRoute(
            name: 'stage3Form',
            path: ':load2Id/form',
            pageBuilder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final load2Id = state.pathParameters['load2Id']!;
              return slideUpPage(
                AdaptiveLayout(
                  mobile: Stage3FormPage(
                    projectId: projectId,
                    load2Id: load2Id,
                  ),
                  web: WebStage3FormPage(
                    projectId: projectId,
                    load2Id: load2Id,
                  ),
                ),
                state,
              );
            },
          ),
          GoRoute(
            name: 'stage3Summary',
            path: ':load2Id/summary',
            pageBuilder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final load2Id = state.pathParameters['load2Id']!;
              return slideUpPage(
                AdaptiveLayout(
                  mobile: Stage3PageSummary(
                    projectId: projectId,
                    load2Id: load2Id,
                  ),
                  web: WebStage3SummaryPage(
                    projectId: projectId,
                    load2Id: load2Id,
                  ),
                ),
                state,
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'stage4Detail',
        path: '${Routes.stage4}/:projectId',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return slideUpPage(
            AdaptiveLayout(
              mobile: Stage4Page(projectId: projectId),
              web: WebStage4Page(projectId: projectId),
            ),
            state,
          );
        },
      ),
      GoRoute(
        name: 'stage5page',
        path: '${Routes.stage5}/:projectId',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return slideUpPage(
            AdaptiveLayout(
              mobile: Stage5Page(projectId: projectId),
              web: WebStage5Page(projectId: projectId),
            ),
            state,
          );
        },
        routes: [
          GoRoute(
            name: 'stage5summary',
            path: 'summary',
            pageBuilder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return slideUpPage(WebStage5Page(projectId: projectId), state);
            },
          ),
          GoRoute(
            name: 'stage5report',
            path: 'report',
            pageBuilder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return slideUpPage(WebStage5Page(projectId: projectId), state);
            },
          ),
          GoRoute(
            name: 'stage5records',
            path: 'records',
            pageBuilder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return slideUpPage(WebStage5Page(projectId: projectId), state);
            },
            routes: [
              GoRoute(
                name: 'stage52form',
                path: 'form',
                pageBuilder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  return slideUpPage(
                    AdaptiveLayout(
                      mobile: Stage52FormPage(projectId: projectId),
                      web: WebStage52FormPage(projectId: projectId),
                    ),
                    state,
                  );
                },
              ),
              GoRoute(
                name: 'stage52edit',
                path: ':id/edit',
                pageBuilder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  final id = state.pathParameters['id'];
                  return slideUpPage(
                    AdaptiveLayout(
                      mobile: Stage52FormPage(projectId: projectId, id: id),
                      web: WebStage52FormPage(projectId: projectId, id: id),
                    ),
                    state,
                  );
                },
              ),
              GoRoute(
                name: 'stage52summary',
                path: ':recordId/summary',
                pageBuilder: (context, state) {
                  final projectId = state.pathParameters['projectId']!;
                  final recordId = state.pathParameters['recordId']!;
                  return slideUpPage(
                    AdaptiveLayout(
                      mobile: Stage52SummaryPage(
                        projectId: recordId,
                        recordId: recordId,
                      ),
                      web: WebStage52SummaryPage(
                        projectId: projectId,
                        recordId: recordId,
                      ),
                    ),
                    state,
                  );
                },
              ),
              GoRoute(
                name: 'stage5invoice',
                path: 'invoice',
                pageBuilder: (context, state) {
                  final extra = state.extra;
                  final invoice = extra is Stage5InvoiceData
                      ? extra
                      : Stage5InvoiceData.fromJson(
                          Map<String, dynamic>.from(extra as Map),
                        );
                  return slideUpPage(
                    AdaptiveLayout(
                      mobile: Stage5InvoiceSummaryPage(invoice: invoice),
                      web: Scaffold(
                        backgroundColor: AppColors.backgroundCrema,
                        body: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: Stage5InvoiceSummaryPage(invoice: invoice),
                          ),
                        ),
                      ),
                    ),
                    state,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: 'adminResetPassword',
        path: '/admin/reset-password',
        pageBuilder: (_, state) =>
            slideUpPage(const AdminResetPasswordPage(), state),
      ),
      GoRoute(
        path: Routes.imageViewer,
        pageBuilder: (_, state) {
          final String image = state.extra as String;
          return slideUpPage(ImageViewer(image: image), state);
        },
      ),
      GoRoute(
        name: 'pdf-preview',
        path: '/pdf-preview',
        pageBuilder: (_, state) {
          final project = state.extra as Stage1FormData;
          return slideUpPage(PdfScreen(project: project), state);
        },
      ),
      GoRoute(
        name: 'inventory',
        path: Routes.inventory,
        pageBuilder: (_, state) => slideUpPage(
          AdaptiveLayout(
            mobile: const MobileInventoryPage(),
            web: const WebInventoryPage(),
            breakpoint: 850,
          ),
          state,
        ),
      ),
      GoRoute(
        path: Routes.splash,
        pageBuilder: (_, state) =>
            noTransitionPage(const SplashScreen(), state),
      ),
    ],
  );
});
