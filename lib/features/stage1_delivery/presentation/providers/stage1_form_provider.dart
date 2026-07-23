import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/compress_image_bytes.dart';
import '../../../../core/storage/application/storage_providers.dart';
import '../../domain/entities/stage1_form_data.dart';
import 'index.dart';
import 'package:registro_panela/features/inventory/domain/entities/inventory_item.dart';
import 'package:registro_panela/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:registro_panela/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:registro_panela/features/molienda/domain/entities/entrega.dart';
import 'package:registro_panela/features/molienda/presentation/providers/molienda_providers.dart';

part 'stage1_form_provider.g.dart';

enum Stage1FormStatus { initial, submitting, success, error }

@riverpod
class Stage1Form extends _$Stage1Form {
  @override
  Stage1FormState build() => const Stage1FormState();

  Future<void> submit(
    Stage1FormData data, {
    required bool isNew,
    Uint8List? photoBytes,
    Stage1FormData? previousData,
  }) async {
    state = state.copyWith(status: Stage1FormStatus.submitting);

    try {
      final compressedPhoto = photoBytes != null
          ? await compressImageBytes(photoBytes)
          : null;

      final dataToSave = compressedPhoto != null
          ? data.copyWith(
              photoPath: await ref.read(uploadImageProvider)(
                path: 'stage1_photos/${data.id}.jpg',
                bytes: compressedPhoto,
              ),
            )
          : data;

      if (isNew) {
        await ref.read(createStage1DataProvider)(dataToSave);

        try {
          final inventoryRepo = ref.read(inventoryRepositoryProvider);
          final inventoryItems = await inventoryRepo.getAll();

          await _applyInventoryDelta(
            inventoryRepo,
            _gaveraQuantitiesByItemId(dataToSave.gaveras, inventoryItems),
            _basketQuantitiesByItemId(dataToSave.baskets, inventoryItems),
            {},
            {},
          );
        } catch (e) {
          ///
        }

        if (dataToSave.moliendaId != null) {
          const uuid = Uuid();
          final entrega = Entrega(
            id: uuid.v4(),
            moliendaId: dataToSave.moliendaId!,
            produccionId: dataToSave.id,
            fechaEntrega: DateTime.now(),
            qrToken: uuid.v4(),
          );
          await ref.read(moliendaRepositoryProvider).createEntrega(entrega);
        }
      } else {
        await ref.read(updateStage1DataProvider)(dataToSave);

        try {
          final inventoryRepo = ref.read(inventoryRepositoryProvider);
          final inventoryItems = await inventoryRepo.getAll();

          await _applyInventoryDelta(
            inventoryRepo,
            _gaveraQuantitiesByItemId(dataToSave.gaveras, inventoryItems),
            _basketQuantitiesByItemId(dataToSave.baskets, inventoryItems),
            _gaveraQuantitiesByItemId(
              previousData?.gaveras ?? const [],
              inventoryItems,
            ),
            _basketQuantitiesByItemId(
              previousData?.baskets ?? const [],
              inventoryItems,
            ),
          );
        } catch (e) {
          ///
        }
      }

      state = state.copyWith(status: Stage1FormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: Stage1FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Map<String, int> _gaveraQuantitiesByItemId(
    List<GaveraData> gaveras,
    List<InventoryItem> inventoryItems,
  ) {
    final quantities = <String, int>{};
    for (final gavera in gaveras) {
      final item = inventoryItems.firstWhereOrNull(
        (i) =>
            i.type == InventoryItemType.gavera &&
            (i.referenceWeight! - gavera.referenceWeight).abs() < 0.001,
      );
      if (item != null) {
        quantities[item.id] = (quantities[item.id] ?? 0) + gavera.quantity;
      }
    }
    return quantities;
  }

  Map<String, int> _basketQuantitiesByItemId(
    List<BasketData> baskets,
    List<InventoryItem> inventoryItems,
  ) {
    final quantities = <String, int>{};
    for (final basket in baskets) {
      final item = inventoryItems.firstWhereOrNull(
        (i) => i.type == InventoryItemType.canastilla && i.size == basket.size,
      );
      if (item != null) {
        quantities[item.id] = (quantities[item.id] ?? 0) + basket.quantity;
      }
    }
    return quantities;
  }

  Future<void> _applyInventoryDelta(
    InventoryRepository inventoryRepo,
    Map<String, int> newGaveraQuantities,
    Map<String, int> newBasketQuantities,
    Map<String, int> previousGaveraQuantities,
    Map<String, int> previousBasketQuantities,
  ) async {
    final gaveraIds = {
      ...newGaveraQuantities.keys,
      ...previousGaveraQuantities.keys,
    };
    for (final id in gaveraIds) {
      final delta =
          (newGaveraQuantities[id] ?? 0) - (previousGaveraQuantities[id] ?? 0);
      if (delta > 0) {
        await inventoryRepo.decrementAvailable(id, delta);
      } else if (delta < 0) {
        await inventoryRepo.incrementAvailable(id, -delta);
      }
    }

    final basketIds = {
      ...newBasketQuantities.keys,
      ...previousBasketQuantities.keys,
    };
    for (final id in basketIds) {
      final delta =
          (newBasketQuantities[id] ?? 0) - (previousBasketQuantities[id] ?? 0);
      if (delta > 0) {
        await inventoryRepo.decrementAvailable(id, delta);
      } else if (delta < 0) {
        await inventoryRepo.incrementAvailable(id, -delta);
      }
    }
  }
}

class Stage1FormState {
  final Stage1FormData? data;
  final Stage1FormStatus status;
  final String? errorMessage;

  const Stage1FormState({
    this.data,
    this.status = Stage1FormStatus.initial,
    this.errorMessage,
  });

  Stage1FormState copyWith({
    Stage1FormData? data,
    Stage1FormStatus? status,
    String? errorMessage,
  }) {
    return Stage1FormState(
      data: data ?? this.data,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
