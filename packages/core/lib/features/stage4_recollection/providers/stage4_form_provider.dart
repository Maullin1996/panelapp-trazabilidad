import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';

import '../domain/entities/stage4_form_data.dart';
import 'stage4_usecases_provider.dart';
import 'package:core/features/inventory/domain/entities/inventory_item.dart';
import 'package:core/features/inventory/providers/inventory_providers.dart';

part 'stage4_form_provider.g.dart';

enum Stage4FormStatus { initial, submitting, success, error }

class Stage4FormState {
  final Stage4FormStatus status;
  final String? errorMessage;
  const Stage4FormState({
    this.status = Stage4FormStatus.initial,
    this.errorMessage,
  });
  Stage4FormState copyWith({Stage4FormStatus? status, String? errorMessage}) =>
      Stage4FormState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

@riverpod
class Stage4Form extends _$Stage4Form {
  @override
  Stage4FormState build() => const Stage4FormState();

  Future<void> submit(Stage4FormData data, {required bool isNew}) async {
    state = state.copyWith(status: Stage4FormStatus.submitting);
    try {
      if (isNew) {
        final createUseCase = ref.read(createStage4DataProvider);
        await createUseCase(data);

        try {
          final inventoryRepo = ref.read(inventoryRepositoryProvider);
          final inventoryItems = await inventoryRepo.getAll();

          for (final gavera in data.returnedGaveras) {
            final item = inventoryItems.firstWhereOrNull(
              (i) =>
                  i.type == InventoryItemType.gavera &&
                  (i.referenceWeight! - gavera.referenceWeight).abs() < 0.001,
            );
            if (item != null && gavera.quantity > 0) {
              await inventoryRepo.incrementAvailable(item.id, gavera.quantity);
            }
          }

          for (final basket in data.returnedBaskets) {
            final item = inventoryItems.firstWhereOrNull(
              (i) =>
                  i.type == InventoryItemType.canastilla &&
                  i.size == basket.size,
            );
            if (item != null && basket.quantity > 0) {
              await inventoryRepo.incrementAvailable(item.id, basket.quantity);
            }
          }
        } catch (e) {
          // El incremento falló pero el registro ya se guardó
        }
      } else {
        final updateUseCase = ref.read(updateStage4DataProvider);
        await updateUseCase(data);
      }

      state = state.copyWith(status: Stage4FormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: Stage4FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
