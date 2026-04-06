import 'package:registro_panela/core/storage/application/storage_providers.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/stage3_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'stage3_form_provider.g.dart';

enum Stage3FormStatus { initial, submitting, success, error }

class Stage3FormState {
  final Stage3FormStatus status;
  final String? errorMessage;
  // ✅ Progreso de subida de fotos: cuántas van y el total
  final int uploadedPhotos;
  final int totalPhotos;

  const Stage3FormState({
    this.status = Stage3FormStatus.initial,
    this.errorMessage,
    this.uploadedPhotos = 0,
    this.totalPhotos = 0,
  });

  // ✅ Porcentaje entre 0.0 y 1.0 para el LinearProgressIndicator
  double get uploadProgress =>
      totalPhotos == 0 ? 0.0 : uploadedPhotos / totalPhotos;

  Stage3FormState copyWith({
    Stage3FormStatus? status,
    String? errorMessage,
    int? uploadedPhotos,
    int? totalPhotos,
  }) => Stage3FormState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    uploadedPhotos: uploadedPhotos ?? this.uploadedPhotos,
    totalPhotos: totalPhotos ?? this.totalPhotos,
  );
}

@riverpod
class Stage3Form extends _$Stage3Form {
  @override
  Stage3FormState build() => const Stage3FormState();

  Future<void> submit(Stage3FormData data, {required bool isNew}) async {
    state = const Stage3FormState(status: Stage3FormStatus.submitting);
    try {
      final dataWithUrls = await _uploadPhotos(
        data,
        // ✅ Conectamos onProgress al estado
        onProgress: (done, total) {
          state = state.copyWith(uploadedPhotos: done, totalPhotos: total);
        },
      );
      if (isNew) {
        final createUseCase = ref.read(createStage3DataProvider);
        await createUseCase(dataWithUrls);
      } else {
        final updateUseCase = ref.read(updateStage3DataProvider);
        await updateUseCase(dataWithUrls);
      }
      state = const Stage3FormState(status: Stage3FormStatus.success);
    } catch (e) {
      state = Stage3FormState(
        status: Stage3FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<Stage3FormData> _uploadPhotos(
    Stage3FormData data, {
    int batchSize = 4,
    int maxRetries = 2,
    void Function(int done, int total)? onProgress,
  }) async {
    final uploadImage = ref.read(uploadImageProvider);

    final baskets = List<BasketWeighData>.from(data.baskets)
      ..sort((a, b) => a.sequence.compareTo(b.sequence));

    final total = baskets.length;
    var done = 0;

    Future<BasketWeighData> uploadOne(BasketWeighData b) async {
      final local = b.photoPath;
      if (local.isEmpty || local.startsWith('http')) {
        onProgress?.call(++done, total);
        return b;
      }

      int attempt = 0;
      while (true) {
        try {
          final storagePath = 'stage3/${data.projectId}/${data.id}/${b.id}.jpg';
          final downloadUrl = await uploadImage(
            path: storagePath,
            localFilePath: local,
          );
          onProgress?.call(++done, total);
          return b.copyWith(photoPath: downloadUrl);
        } catch (e) {
          if (attempt >= maxRetries) rethrow;
          final delayMs = 500 * (1 << attempt);
          await Future.delayed(Duration(milliseconds: delayMs));
          attempt++;
        }
      }
    }

    final updated = <BasketWeighData>[];
    for (var i = 0; i < baskets.length; i += batchSize) {
      final end = (i + batchSize < baskets.length)
          ? i + batchSize
          : baskets.length;
      final chunk = baskets.sublist(i, end);
      final results = await Future.wait(chunk.map(uploadOne));
      updated.addAll(results);
    }

    return data.copyWith(baskets: updated);
  }
}
