import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/stage5_missing_weight.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/stage52_page.dart';
import 'package:registro_panela/features/stage5_summary/presentation/stage5_summary.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class Stage5Page extends ConsumerStatefulWidget {
  final String projectId;
  const Stage5Page({super.key, required this.projectId});

  @override
  ConsumerState<Stage5Page> createState() => _Stage5PageState();
}

class _Stage5PageState extends ConsumerState<Stage5Page> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId))!;

    final screens = [
      Stage5Summary(projectId: widget.projectId),
      Stage5MissingWeight(projectId: widget.projectId),
      Stage52Page(projectId: widget.projectId),
    ];

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name, style: textTheme.headlineLarge),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) => setState(() => selectedIndex = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.weakSummary),
            label: 'Resumen',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.reporte),
            label: 'Reporte',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.finalRecord),
            label: 'Entrega',
          ),
        ],
      ),
    );
  }
}
