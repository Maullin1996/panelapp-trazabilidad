import 'package:flutter/material.dart';
import 'package:core/shared/stage5_missing_weight.dart';

class WebStage5MissingWeight extends StatelessWidget {
  final String projectId;
  const WebStage5MissingWeight({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Stage5MissingWeight(projectId: projectId),
      ),
    );
  }
}
