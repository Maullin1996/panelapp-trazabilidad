import 'package:flutter/material.dart';
import 'package:core/shared/stage5_summary.dart';

class WebStage5Summary extends StatelessWidget {
  final String projectId;
  const WebStage5Summary({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Stage5Summary(projectId: projectId),
      ),
    );
  }
}
