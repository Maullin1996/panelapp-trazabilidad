import 'dart:typed_data';

import '../../../core/storage/application/storage_providers.dart';
import '../domain/entities/stage1_form_data.dart';
import 'index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      final dataToSave = photoBytes != null
          ? data.copyWith(
              photoPath: await ref.read(uploadImageProvider)(
                path: 'stage1_photos/${data.id}.jpg',
                bytes: photoBytes,
              ),
            )
          : data;

      if (isNew) {
        await ref.read(createStage1DataProvider)(dataToSave);
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
