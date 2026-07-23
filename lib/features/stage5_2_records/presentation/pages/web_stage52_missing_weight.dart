import 'package:flutter/material.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/pages/stage52_missing_weight.dart';

class WebStage52MissingWeight extends StatelessWidget {
  final String projectId;
  const WebStage52MissingWeight({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Stage52MissingWeight(projectId: projectId),
      ),
    );
  }
}
