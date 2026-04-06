import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/index.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import 'package:registro_panela/features/pdf/helpers/generate_and_share_pdf.dart';

class ProjectSelectorPage extends ConsumerStatefulWidget {
  const ProjectSelectorPage({super.key});

  @override
  ConsumerState<ProjectSelectorPage> createState() =>
      _ProjectSelectorPageState();
}

class _ProjectSelectorPageState extends ConsumerState<ProjectSelectorPage> {
  Set<String> isSelected = {};

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (previous?.authStatus != next.authStatus) {
        if (next.authStatus == AuthStatus.notAuthenticated) {
          context.go(Routes.login);
        } else if (next.errorMessage?.isNotEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo cerrar el usuario')),
          );
        }
      }
    });

    final projects = ref.watch(syncStage1ProjectsProvider);
    final error = ref.watch(stage1ProjectsErrorProvider);
    final user = ref.watch(authProvider).user;
    final textTheme = TextTheme.of(context);
    final body = _buildBody(projects, error, textTheme);

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            color: AppColors.cardBackground,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'users':
                  context.pushNamed('adminResetPassword');
                case 'logout':
                  ref.read(authProvider.notifier).logout();
                case 'preview':
                  final selectedProject = projects.firstWhere(
                    (p) => p.id == isSelected.first,
                  );
                  context.pushNamed('pdf-preview', extra: selectedProject);
                  setState(() => isSelected.clear());
                case 'print':
                  final selectedProject = projects.firstWhere(
                    (p) => p.id == isSelected.first,
                  );
                  await generateAndSharePdf(selectedProject);
                  setState(() => isSelected.clear());
              }
            },
            itemBuilder: (BuildContext context) => [
              if (user!.role == UserRole.admin)
                const PopupMenuItem<String>(
                  value: 'users',
                  child: Text(
                    'Usuarios',
                    style: TextStyle(
                      fontFamily: AppTypography.familyRoboto,
                      fontSize: 20,
                    ),
                  ),
                ),
              if (isSelected.isNotEmpty) ...[
                const PopupMenuItem<String>(
                  value: 'preview',
                  child: Text(
                    'Vista previa PDF',
                    style: TextStyle(
                      fontFamily: AppTypography.familyRoboto,
                      fontSize: 20,
                    ),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'print',
                  child: Text(
                    'Imprimir',
                    style: TextStyle(
                      fontFamily: AppTypography.familyRoboto,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.smallLarge),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              key: const Key('project-selector-create-project-button'),
              label: Text('Crear proyecto', style: textTheme.headlineLarge),
              icon: const Icon(
                Icons.add_outlined,
                color: Color(0xFF3A2B1F),
                size: 30,
              ),
              onPressed: () {
                if (user != null &&
                    (user.role == UserRole.admin ||
                        user.role == UserRole.stage1)) {
                  context.push('${Routes.stage1}/new');
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
      body: body,
    );
  }

  Widget _buildBody<T>(List<T> projects, String? error, TextTheme textTheme) {
    if (error != null) {
      return _buildErrorBody(error);
    }

    if (projects.isEmpty) {
      return _buildEmptyState();
    }

    return _buildProjectList(projects, textTheme);
  }

  Widget _buildEmptyState() {
    return const EmptyWidget();
  }

  Widget _buildErrorBody(String error) {
    return ErrorWidgetCustom(error: error);
  }

  Widget _buildProjectList<T>(List<T> projects, TextTheme textTheme) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.small,
        top: AppSpacing.smallLarge,
      ),
      itemCount: projects.length,
      itemBuilder: (context, i) {
        final p = projects[i] as dynamic;
        final user = ref.read(authProvider).user;
        return Dismissible(
          key: Key('project-selector-dismissible-${p.id}'),
          direction: user != null && user.role == UserRole.admin
              ? DismissDirection.endToStart
              : DismissDirection.none,
          confirmDismiss: (_) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.cardBackground,
                    title: Text(
                      '¿Eliminar proyecto?',
                      style: textTheme.headlineLarge,
                    ),
                    content: Text(
                      'Esta acción no se puede deshacer.',
                      style: textTheme.bodyLarge,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancelar', style: textTheme.bodyLarge),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
          },
          onDismissed: (_) async {
            await ref.read(deleteStage1DataProvider)(p.id);
          },
          background: Container(
            margin: const EdgeInsets.only(
              left: AppSpacing.smallLarge,
              right: AppSpacing.smallLarge,
              bottom: AppSpacing.small,
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.smallLarge),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),
          child: CustomCard(
            key: Key('project-selector-custom-card-${p.id}'),
            isSelected: isSelected.contains(p.id)
                ? AppColors.selectedColor
                : AppColors.cardBackground,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(p.name, style: textTheme.headlineLarge),
                      ),
                      Text(
                        DateFormat.yMd().format(p.date),
                        style: textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  const Divider(thickness: 2),
                  const SizedBox(height: AppSpacing.xSmall),
                  Row(
                    children: [
                      const Icon(
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
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomRichText(
                    firstText: 'Canastillas: ',
                    secondText: '${p.basketsQuantity}',
                    icon: Icons.shopping_basket,
                    iconColor: AppColors.register,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomRichText(
                    firstText: 'Contacto: ',
                    secondText: p.phone,
                    icon: Icons.phone,
                  ),
                ],
              ),
              onTap: () => _onProjectTap(p),
              onLongPress: () => _onProjectLongPress(p.id),
            ),
          ),
        );
      },
    );
  }

  void _onProjectTap(p) {
    final user = ref.read(authProvider).user;
    if (user?.role == UserRole.admin) {
      context.push('${Routes.projects}${Routes.stages}/${p.id}');
    } else {
      context.push('${_routeForRole(user!.role)}/${p.id}');
    }
    setState(() => isSelected.clear());
  }

  void _onProjectLongPress(String id) {
    setState(() {
      if (isSelected.contains(id)) {
        isSelected.remove(id);
      } else {
        isSelected.add(id);
      }
    });
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
