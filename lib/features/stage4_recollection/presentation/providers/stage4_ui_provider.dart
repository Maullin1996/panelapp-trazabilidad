import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_ui_state.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/sync_stage4_data_provider.dart';
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

    final totalBaskets = entries.fold<int>(0, (previousValue, element) {
      if (previousValue + element.returnedBaskets > project.basketsQuantity) {
        return project.basketsQuantity;
      } else {
        return previousValue + element.returnedBaskets;
      }
    });
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
      returnedBaskets: totalBaskets,
      returnedPreservativesJars: totalPreservatives,
      returnedLimeJars: totalLime,
    );
  }
}
