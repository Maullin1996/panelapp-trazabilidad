import 'dart:typed_data';

import '../../../core/storage/application/storage_providers.dart';
import '../domain/entities/stage52_record_data.dart';
import 'stage52_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage52_form_status.g.dart';

enum Stage52FormStatus { initial, submitting, success, error }

class Stage52FormState {
  final Stage52FormStatus status;
  final String? errorMessage;
  const Stage52FormState({
    this.status = Stage52FormStatus.initial,
    this.errorMessage,
  });
}

@riverpod
class Stage52Form extends _$Stage52Form {
  @override
  Stage52FormState build() => const Stage52FormState();

  Future<void> submit({
    required Stage52RecordData data,
    required bool isNew,
    Uint8List? photoBytes,
  }) async {
    state = const Stage52FormState(status: Stage52FormStatus.submitting);
    try {
      if (photoBytes != null) {
        final uploadImage = ref.read(uploadImageProvider);
        final downloadUrl = await uploadImage(
          path: 'stage52_photos/${data.id}.jpg',
          bytes: photoBytes,
        );
        data = data.copyWith(photoPath: downloadUrl);
      }
      if (isNew) {
        await ref.read(createStage52DataProvider)(data);
      } else {
        await ref.read(updateStage52DataProvider)(data);
      }
      state = const Stage52FormState(status: Stage52FormStatus.success);
    } catch (e) {
      state = Stage52FormState(
        status: Stage52FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
