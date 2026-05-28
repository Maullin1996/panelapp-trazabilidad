import '../../stage1_delivery/domain/entities/stage1_form_data.dart';
import '../../stage1_delivery/providers/stage1_project_by_id_provider.dart';
import '../domain/entities/stage4_form_data.dart';
import '../domain/entities/stage4_ui_state.dart';
import 'sync_stage4_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage4_ui_provider.g.dart';

@riverpod
class Stage4Ui extends _$Stage4Ui {
  @override
  Stage4UiState build(String projectId) {
    final entries = ref.watch(syncStage4DataProvider(projectId));

    final project = ref.watch(stage1ProjectByIdProvider(projectId))!;

    final aggregatedGaveras = List<ReturnedGaveras>.generate(
      project.gaveras.length,
      (index) => ReturnedGaveras(
        quantity: 0,
        referenceWeight: project.gaveras[index].referenceWeight,
      ),
    );

    for (final entry in entries) {
      for (int i = 0; i < entry.returnedGaveras.length; i++) {
        final prev = aggregatedGaveras[i].quantity;
        final add = entry.returnedGaveras[i].quantity;
        if (prev + add > project.gaveras[i].quantity) {
          aggregatedGaveras[i] = aggregatedGaveras[i].copyWith(
            quantity: project.gaveras[i].quantity,
          );
        } else {
          aggregatedGaveras[i] = aggregatedGaveras[i].copyWith(
            quantity: (prev + add).toInt(),
          );
        }
      }
    }

    // Reemplaza el fold de totalBaskets por agrupación por size:
    final returnedBySize = <BasketSize, int>{};
    for (final entry in entries) {
      for (final b in entry.returnedBaskets) {
        returnedBySize[b.size] = (returnedBySize[b.size] ?? 0) + b.quantity;
      }
    }

    final returnedBaskets = project.baskets.map((b) {
      final returned = returnedBySize[b.size] ?? 0;
      final capped = returned > b.quantity ? b.quantity : returned;
      return ReturnedBaskets(size: b.size, quantity: capped);
    }).toList();

    final totalPreservatives = entries.fold<int>(0, (previousValue, element) {
      final sum = previousValue + element.returnedPreservativesJars;
      return sum > project.preservativesJars ? project.preservativesJars : sum;
    });
    final totalLime = entries.fold(0, (previousValue, element) {
      final sum = previousValue + element.returnedLimeJars;
      return sum > project.limeJars ? project.limeJars : sum;
    });

    return Stage4UiState(
      returnedGaveras: aggregatedGaveras,
      returnedBaskets: returnedBaskets,
      returnedPreservativesJars: totalPreservatives,
      returnedLimeJars: totalLime,
    );
  }
}
