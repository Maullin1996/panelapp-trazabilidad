import 'package:registro_panela/core/storage/application/storage_providers.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_load_provider.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'stage3_form_provider.g.dart';

enum Stage3FormStatus { initial, submitting, success, error }

class Stage3FormState {
  final Stage3FormData? data;
  final Stage3FormStatus status;
  final String? errorMessage;
  const Stage3FormState({
    this.data,
    this.status = Stage3FormStatus.initial,
    this.errorMessage,
  });
  Stage3FormState copyWith({
    Stage3FormData? data,
    Stage3FormStatus? status,
    String? errorMessage,
  }) => Stage3FormState(
    data: data ?? this.data,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

@riverpod
class Stage3Form extends _$Stage3Form {
  @override
  Stage3FormState build() => const Stage3FormState();

  Future<void> submit(Stage3FormData data, {required bool isNew}) async {
    state = state.copyWith(status: Stage3FormStatus.submitting);
    try {
      final dataWithUrls = await _uploadPhotos(data);
      if (isNew) {
        final createUseCase = ref.read(createStage3DataProvider);
        await createUseCase(dataWithUrls);
      } else {
        final updateUseCase = ref.read(updateStage3DataProvider);
        await updateUseCase(dataWithUrls);
      }
      ref.invalidate(stage3LoadProvider);
      state = state.copyWith(
        status: Stage3FormStatus.success,
        data: dataWithUrls,
      );
    } catch (e) {
      state = state.copyWith(
        status: Stage3FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<Stage3FormData> _uploadPhotos(Stage3FormData data) async {
    final uploadImage = ref.read(uploadImageProvider);

    final futures = data.baskets.map((b) async {
      final local = b.photoPath;

      if (local.isNotEmpty && !local.startsWith('https')) {
        final storagePath = 'stage3/${data.projectId}/${data.id}/${b.id}.jpg';
        final downloadUrl = await uploadImage(
          path: storagePath,
          localFilePath: local,
        );
        return b.copyWith(photoPath: downloadUrl);
      }
      return b;
    });
    final updatedBaskets = await Future.wait(futures);
    return data.copyWith(baskets: updatedBaskets);
  }
}
