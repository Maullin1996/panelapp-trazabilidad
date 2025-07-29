import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:registro_panela/features/stage1_delivery/providers/index.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';

class ProjectSelectorPage extends ConsumerWidget {
  const ProjectSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (previous?.authStatus != next.authStatus) {
        if (next.authStatus == AuthStatus.notAuthenticated) {
          context.go(Routes.login);
        } else if (next.errorMessage?.isNotEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo cerrar el usuario')),
          );
        }
      }
    });

    final projects = ref.watch(syncStage1ProjectsProvider);
    final error = ref.watch(stage1ProjectsErrorProvider);
    final user = ref.watch(authProvider).user;
    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    fontFamily: AppTypography.familyRoboto,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
        title: Text('Seleccionar Proyecto', style: textTheme.headlineLarge),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Sólo admin y stage1 pueden crear
      //     if (user != null &&
      //         (user.role == UserRole.admin || user.role == UserRole.stage1)) {
      //       context.go('${Routes.stage1}/new');
      //     } else {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(
      //           content: Text('Sólo admin o Stage1 pueden crear proyectos'),
      //           backgroundColor: Colors.red,
      //         ),
      //       );
      //     }
      //   },
      //   child: const Icon(Icons.add_outlined),
      // ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
              ),
              icon: const Icon(Icons.add_outlined),
              label: const Text('Crear proyecto'),
              onPressed: () {
                // Sólo admin y stage1 pueden crear
                if (user != null &&
                    (user.role == UserRole.admin ||
                        user.role == UserRole.stage1)) {
                  context.go('${Routes.stage1}/new');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Sólo admin o Stage1 pueden crear proyectos',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: (error != null)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Ocurrió un error al cargar los proyectos'),
                  SizedBox(height: 8),
                  Text(error, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.read(stage1ProjectsProvider.notifier).refresh(),
                    icon: Icon(Icons.refresh),
                    label: Text('Reintentar'),
                  ),
                ],
              ),
            )
          : (projects.isEmpty)
          ? const Center(child: Text('No hay proyectos disponibles.'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: AppSpacing.large),
              itemCount: projects.length,
              itemBuilder: (context, i) {
                final p = projects[i];
                return CustomCard(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                p.name,
                                style: textTheme.headlineLarge,
                              ),
                            ),
                            Text(
                              DateFormat.yMd().format(p.date),
                              style: textTheme.bodyLarge?.copyWith(),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        const Divider(),
                        const SizedBox(height: AppSpacing.xSmall),
                        Row(
                          children: [
                            Icon(Icons.storage, size: 20.0),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text('Gaveras', style: textTheme.headlineMedium),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        ...List.generate(
                          p.gaveras.length,
                          (index) => Row(
                            children: [
                              Text(
                                '• Cantidad: ${p.gaveras[index].quantity} - Peso ${p.gaveras[index].referenceWeight} g',
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.xSmall),
                        Row(
                          children: [
                            Icon(Icons.shopping_basket, size: 20),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text(
                              'Canastillas:',
                              style: textTheme.headlineMedium,
                            ),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text('${p.basketsQuantity}'),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xSmall),

                        SizedBox(height: AppSpacing.xSmall),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 20),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text('Contacto:', style: textTheme.headlineMedium),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text(p.phone),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      if (user?.role == UserRole.admin) {
                        _showAdminStageSelector(context, p.id);
                      } else {
                        final route = _routeForRole(user!.role);
                        context.go('$route/${p.id}');
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  String _routeForRole(UserRole role) {
    switch (role) {
      case UserRole.stage1:
        return Routes.stage1;
      case UserRole.stage2:
        return Routes.stage2;
      case UserRole.stage3:
        return Routes.stage3;
      case UserRole.stage4:
        return Routes.stage4;
      case UserRole.stage5:
        return Routes.stage5;
      default:
        return Routes.projects;
    }
  }

  void _showAdminStageSelector(BuildContext context, String projectId) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 1.0,
        minChildSize: 1.0,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.smallLarge,
              ),
              children: [
                SizedBox(height: AppSpacing.mediumLarge),
                for (var stage = 1; stage <= 5; stage++)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.smallLarge),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsetsGeometry.all(
                          AppSpacing.small,
                        ),
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Bordes redondeados
                        ),
                        leading: Icon(
                          _iconForStage(stage),
                          size: 30,
                          color: Colors.black,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                        title: Text(
                          _stageName(stage),
                          style: TextTheme.of(
                            context,
                          ).headlineMedium?.copyWith(color: Colors.black),
                        ),
                        subtitle: Text(
                          'Proyecto: Porno de ancianos',
                          style: TextTheme.of(
                            context,
                          ).bodyLarge?.copyWith(color: Colors.black54),
                        ),
                        onTap: () => context.go('${byStage(stage)}/$projectId'),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _iconForStage(int stage) {
    switch (stage) {
      case 1:
        return AppIcons.deliversSupplies;
      case 2:
        return AppIcons.collect;
      case 3:
        return AppIcons.weighing;
      case 4:
        return AppIcons.pickUpSupplies;
      case 5:
        return AppIcons.summarize;
      default:
        return Icons.help;
    }
  }

  String _stageName(int stage) {
    switch (stage) {
      case 1:
        return 'Entrega';
      case 2:
        return 'Cargue';
      case 3:
        return 'Pesado';
      case 4:
        return 'Recogida molienda';
      case 5:
        return 'Liquidación';
      default:
        return 'No encontrado';
    }
  }
}

String byStage(int n) {
  switch (n) {
    case 1:
      return Routes.stage1;
    case 2:
      return Routes.stage2;
    case 3:
      return Routes.stage3;
    case 4:
      return Routes.stage4;
    case 5:
      return Routes.stage5;
    default:
      return Routes.projects;
  }
}
