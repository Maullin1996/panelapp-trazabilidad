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
import 'package:registro_panela/shared/widgets/widgets.dart';

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
            color: AppColors.cardBackground,
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
        centerTitle: true,
        title: Text('Seleccionar Proyecto', style: textTheme.headlineLarge),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.smallLarge),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              label: Text('Crear proyecto', style: textTheme.headlineLarge),
              icon: const Icon(
                Icons.add_outlined,
                color: Color(0xFF3A2B1F),
                size: 30,
              ),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        const Divider(thickness: 4, color: Colors.black),
                        const SizedBox(height: AppSpacing.xSmall),
                        Row(
                          children: [
                            Icon(
                              Icons.storage,
                              size: 20.0,
                              color: AppColors.weight,
                            ),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text('Gaveras', style: textTheme.headlineMedium),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        ...List.generate(
                          p.gaveras.length,
                          (index) => Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '• Cantidad: ${p.gaveras[index].quantity} - Peso ${p.gaveras[index].referenceWeight} g',
                                  style: textTheme.bodyLarge,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.xSmall),
                        CustomRichText(
                          firstText: 'Canastillas: ',
                          secondText: '${p.basketsQuantity}',
                          icon: Icons.shopping_basket,
                          iconColor: AppColors.register,
                        ),

                        SizedBox(height: AppSpacing.xSmall),

                        CustomRichText(
                          firstText: 'Contacto: ',
                          secondText: p.phone,
                          icon: Icons.phone,
                        ),
                      ],
                    ),
                    onTap: () {
                      if (user?.role == UserRole.admin) {
                        context.go(
                          '${Routes.projects}${Routes.stages}/${p.id}',
                        );
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
