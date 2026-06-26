import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/compress_image_bytes.dart';
import '../../../core/storage/application/storage_providers.dart';
import '../domain/entities/stage1_form_data.dart';
import 'index.dart';
import 'package:core/features/inventory/domain/entities/inventory_item.dart';
import 'package:core/features/inventory/providers/inventory_providers.dart';
import 'package:core/features/molienda/domain/entities/entrega.dart';
import 'package:core/features/molienda/providers/molienda_providers.dart';

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

          for (final gavera in dataToSave.gaveras) {
            final item = inventoryItems.firstWhereOrNull(
              (i) =>
                  i.type == InventoryItemType.gavera &&
                  (i.referenceWeight! - gavera.referenceWeight).abs() < 0.001,
            );
            if (item != null && gavera.quantity > 0) {
              await inventoryRepo.decrementAvailable(item.id, gavera.quantity);
            }
          }

          for (final basket in dataToSave.baskets) {
            final item = inventoryItems.firstWhereOrNull(
              (i) =>
                  i.type == InventoryItemType.canastilla &&
                  i.size == basket.size,
            );
            if (item != null && basket.quantity > 0) {
              await inventoryRepo.decrementAvailable(item.id, basket.quantity);
            }
          }
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
      }

      state = state.copyWith(status: Stage1FormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: Stage1FormStatus.error,
        errorMessage: e.toString(),
      );
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
