import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:registro_panela_web/feature/stage5/web_stage5_summaty.dart';
import 'package:registro_panela_web/feature/stage5/web_stage5_missing_weight.dart';
import '../shared/web_layout.dart';
import 'web_stage52_page.dart';

class WebStage5Page extends ConsumerStatefulWidget {
  final String projectId;
  const WebStage5Page({super.key, required this.projectId});

  @override
  ConsumerState<WebStage5Page> createState() => _WebStage5PageState();
}

class _WebStage5PageState extends ConsumerState<WebStage5Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId));
    final textTheme = TextTheme.of(context);

    if (project == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WebLayout(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
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
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Text(
                  project.name.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
                const Spacer(),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: AppColors.primaryPanelaBrown,
                  labelColor: AppColors.primaryPanelaBrown,
                  unselectedLabelColor: AppColors.textDark.withAlpha(150),
                  tabs: const [
                    Tab(icon: Icon(Icons.summarize), text: 'Resumen'),
                    Tab(icon: Icon(Icons.report), text: 'Reporte'),
                    Tab(icon: Icon(Icons.inventory), text: 'Entrega'),
                  ],
                ),
              ],
            ),
          ),

          // ── Contenido ─────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // pon esto
                WebStage5Summary(projectId: widget.projectId),
                WebStage5MissingWeight(projectId: widget.projectId),
                WebStage52Page(projectId: widget.projectId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
