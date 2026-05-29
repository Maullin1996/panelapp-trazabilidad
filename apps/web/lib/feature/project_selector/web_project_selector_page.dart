import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/features/stage1_delivery/providers/index.dart';
import 'package:core/features/auth/providers/auth_provider.dart';
import 'package:core/features/auth/domain/enums/index.dart';
import 'package:core/features/auth/domain/entities/index.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_enums_labels.dart';
import 'package:core/core/router/routes.dart';
import 'package:core/shared/widgets/widgets.dart';
import 'package:core/shared/utils/tokens.dart';
import '../shared/web_layout.dart';
import '../shared/web_stage_selector_dialog.dart';

class WebProjectSelectorPage extends ConsumerStatefulWidget {
  const WebProjectSelectorPage({super.key});

  @override
  ConsumerState<WebProjectSelectorPage> createState() =>
      _WebProjectSelectorPageState();
}

class _WebProjectSelectorPageState
    extends ConsumerState<WebProjectSelectorPage> {
  Set<String> isSelected = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
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
      if (notifier.canLoadMore(projects)) notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (previous?.authStatus != next.authStatus) {
        if (next.authStatus == AuthStatus.notAuthenticated) {
          context.go(Routes.login);
        }
      }
    });

    final projects = ref.watch(syncStage1ProjectsProvider);
    final error = ref.watch(stage1ProjectsErrorProvider);
    final isLoading = ref.watch(stage1ProjectsLoadingProvider);
    final user = ref.watch(authProvider).user;
    final textTheme = TextTheme.of(context);

    return WebLayout(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (index == 1) context.pushNamed('adminResetPassword');
      },
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.secondaryDarkPanela.withAlpha(30),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Proyectos'.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
                const Spacer(),
                if (user != null &&
                    (user.role == UserRole.admin ||
                        user.role == UserRole.stage1))
                  ElevatedButton.icon(
                    onPressed: () => context.push('${Routes.stage1}/new'),
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.cardBackground,
                    ),
                    label: Text(
                      'Nuevo proyecto',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.cardBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSpacing.small),
                IconButton(
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  tooltip: 'Cerrar sesión',
                ),
              ],
            ),
          ),

          // ── Contenido ─────────────────────────────────────────
          Expanded(child: _buildBody(projects, error, isLoading, textTheme)),
        ],
      ),
    );
  }

  Widget _buildBody(
    List<Stage1FormData> projects,
    String? error,
    bool isLoading,
    TextTheme textTheme,
  ) {
    if (error != null) return ErrorWidgetCustom(error: error);
    if (isLoading && projects.isEmpty) {
      return const ProjectSelectorShimmer(itemCount: 6);
    }
    if (projects.isEmpty) return const EmptyWidget();

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.medium),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        mainAxisSpacing: AppSpacing.small,
        crossAxisSpacing: AppSpacing.small,
        childAspectRatio: 1.1,
      ),
      itemCount: projects.length,
      itemBuilder: (context, i) {
        final p = projects[i];
        return GestureDetector(
          onTap: () => _onProjectTap(p),
          onLongPress: () => _onProjectLongPress(p.id),
          child: CustomCard(
            isSelected: isSelected.contains(p.id)
                ? AppColors.selectedColor
                : AppColors.cardBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Row(
                    children: [
                      IconDecoration(
                        icon: Icons.settings_suggest,
                        iconColor: AppColors.primaryPanelaBrown,
                      ),
                      const SizedBox(width: AppSpacing.xSmall),
                      Expanded(
                        child: Text(
                          p.name,
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryPanelaBrown,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        DateFormat.yMd().format(p.date),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryPanelaBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                  ),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.secondaryDarkPanela.withAlpha(45),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        ...p.gaveras.map(
                          (g) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                              left: AppSpacing.small,
                            ),
                            child: Wrap(
                              spacing: 6,
                              children: [
                                _Chip(
                                  'unidades: ${g.quantity}',
                                  AppColors.weight,
                                ),
                                _Chip(
                                  '${g.referenceWeight} g',
                                  AppColors.secondaryDarkPanela,
                                ),
                                _Chip(
                                  g.gaveraType.label,
                                  AppColors.primaryPanelaBrown,
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
                ),
              ],
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
      showDialog(
        context: context,
        builder: (_) => WebStageSelectorDialog(projectId: p.id),
      );
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

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTypography.body,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
