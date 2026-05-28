import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/auth/domain/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domain/enums/auth_status.dart';
import 'package:registro_panela/features/auth/domain/enums/user_role.dart';
import 'package:registro_panela/features/auth/presentation/providers/auth_provider.dart';
import 'package:registro_panela/features/project_selector/widgets/project_selector_shimmer.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/index.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import 'package:registro_panela/features/pdf/helpers/generate_and_share_pdf.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_enums_labels.dart';

class ProjectSelectorPage extends ConsumerStatefulWidget {
  const ProjectSelectorPage({super.key});

  @override
  ConsumerState<ProjectSelectorPage> createState() =>
      _ProjectSelectorPageState();
}

class _ProjectSelectorPageState extends ConsumerState<ProjectSelectorPage> {
  Set<String> isSelected = {};
  final ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final isNearBottom = position.pixels >= position.maxScrollExtent - 200;
    if (isNearBottom) {
      final notifier = ref.read(stage1ProjectsProvider.notifier);
      final projects = ref.read(syncStage1ProjectsProvider);

      if (notifier.canLoadMore(projects)) {
        notifier.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (previous?.authStatus != next.authStatus) {
        if (next.authStatus == AuthStatus.notAuthenticated) {
          context.go(Routes.login);
        } else if (next.errorMessage?.isNotEmpty == true) {
          CustomSnackBar.show(
            context,
            message: 'No se pudo cerrar el usuario',
            status: SnackbarStatus.error,
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xSmall),
            borderRadius: BorderRadius.circular(AppRadius.large),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
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
                  child: _PopMenuDecoracion(
                    text: 'Usuarios',
                    backGroundcolor: AppColors.weight,
                  ),
                ),
              if (isSelected.isNotEmpty) ...[
                const PopupMenuItem<String>(
                  value: 'preview',
                  child: _PopMenuDecoracion(
                    text: 'Vista previa PDF',
                    backGroundcolor: AppColors.weight,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'print',
                  child: _PopMenuDecoracion(
                    text: 'Imprimir',
                    backGroundcolor: AppColors.weight,
                  ),
                ),
              ],
              const PopupMenuItem<String>(
                value: 'logout',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: AppColors.weight, thickness: 0.5),
                    _PopMenuDecoracion(
                      text: 'Cerrar sesión',
                      backGroundcolor: AppColors.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        title: Text(
          'Seleccionar Proyecto'.toUpperCase(),
          style: textTheme.headlineMedium,
        ),
      ),
      bottomNavigationBar:
          (user != null &&
              (user.role == UserRole.admin || user.role == UserRole.stage1))
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.smallLarge),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: const Key('project-selector-create-project-button'),
                    label: Text(
                      'Crear proyecto',
                      style: textTheme.headlineLarge?.copyWith(
                        color: AppColors.cardBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: const Icon(
                      Icons.add_outlined,
                      color: AppColors.cardBackground,
                      size: 30,
                    ),
                    onPressed: () {
                      context.push('${Routes.stage1}/new');
                    },
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(child: body),
    );
  }

  Widget _buildBody<T>(List<T> projects, String? error, TextTheme textTheme) {
    if (error != null) {
      return _buildErrorBody(error);
    }

    final isLoading = ref.watch(stage1ProjectsLoadingProvider);
    if (isLoading && projects.isEmpty) {
      return const ProjectSelectorShimmer(itemCount: 5);
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
    final typedProjects = projects.cast<Stage1FormData>();
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.small),
      padding: const EdgeInsets.only(
        bottom: AppSpacing.small,
        left: AppSpacing.small,
        right: AppSpacing.small,
        top: AppSpacing.smallLarge,
      ),
      itemCount: typedProjects.length,
      itemBuilder: (context, i) {
        final p = typedProjects[i];
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
          background: DismissbleBackgraoundContainer(),
          child: GestureDetector(
            onTap: () => _onProjectTap(p),
            onLongPress: () => _onProjectLongPress(p.id),
            child: CustomCard(
              key: Key('project-selector-custom-card-${p.id}'),
              isSelected: isSelected.contains(p.id)
                  ? AppColors.selectedColor
                  : AppColors.cardBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.small,
                      right: AppSpacing.small,
                      top: AppSpacing.xSmall,
                    ),
                    child: Row(
                      children: [
                        IconDecoration(
                          icon: Icons.settings_suggest,
                          iconColor: AppColors.primaryPanelaBrown,
                        ),
                        SizedBox(width: AppSpacing.xSmall),
                        Expanded(
                          child: Text(
                            p.name,
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryPanelaBrown,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat.yMd().format(p.date),
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryPanelaBrown,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.small,
                      vertical: AppSpacing.xSmall,
                    ),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.secondaryDarkPanela.withAlpha(45),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.small,
                      left: AppSpacing.small,
                      right: AppSpacing.small,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const IconDecoration(
                              icon: Icons.storage,
                              iconColor: AppColors.weight,
                              backgroundColor: AppColors.weight,
                            ),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text('Gaveras', style: textTheme.headlineMedium),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        ...List.generate(
                          p.gaveras.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                              left: AppSpacing.small,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.weight.withAlpha(30),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.small,
                                    ),
                                  ),
                                  child: Text(
                                    'unidades: ${p.gaveras[index].quantity} de',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.weight,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryDarkPanela
                                        .withAlpha(20),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.small,
                                    ),
                                  ),
                                  child: Text(
                                    '${p.gaveras[index].referenceWeight} g',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryDarkPanela,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  // ← nuevo chip
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPanelaBrown
                                        .withAlpha(20),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.small,
                                    ),
                                  ),
                                  child: Text(
                                    p.gaveras[index].gaveraType.label,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryPanelaBrown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        Row(
                          children: [
                            const IconDecoration(
                              icon: Icons.shopping_basket,
                              iconColor: AppColors.register,
                              backgroundColor: AppColors.register,
                            ),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text(
                              'Canastillas',
                              style: textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        ...List.generate(
                          p.baskets.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                              left: AppSpacing.small,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.register.withAlpha(30),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.small,
                                    ),
                                  ),
                                  child: Text(
                                    'unidades: ${p.baskets[index].quantity}',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.register,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryDarkPanela
                                        .withAlpha(20),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.small,
                                    ),
                                  ),
                                  child: Text(
                                    p.baskets[index].size.label,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryDarkPanela,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        CustomRichText(
                          firstText: 'Contacto: ',
                          secondText: p.phone,
                          icon: Icons.phone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onProjectTap(Stage1FormData p) {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    if (user.role == UserRole.admin) {
      context.push('${Routes.projects}${Routes.stages}/${p.id}');
    } else {
      context.push('${_routeForRole(user.role)}/${p.id}');
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

class _PopMenuDecoracion extends StatelessWidget {
  final String text;
  final Color backGroundcolor;

  const _PopMenuDecoracion({required this.text, required this.backGroundcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xSmall,
        vertical: AppSpacing.xSmall,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backGroundcolor.withAlpha(38),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTypography.familyRoboto,
          fontSize: AppTypography.body,
        ),
      ),
    );
  }
}
