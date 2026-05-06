import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';

final stage52SummaryProvider =
    Provider.family<({int units, double kg, int count}), String>((
      ref,
      projectId,
    ) {
      final records = ref.watch(stage52ByProjectProvider(projectId));
      return (
        count: records.length,
        units: records.fold(0, (s, r) => s + r.unitCount),
        kg: records.fold(0, (s, r) => s + r.panelaWeight),
      );
    });
