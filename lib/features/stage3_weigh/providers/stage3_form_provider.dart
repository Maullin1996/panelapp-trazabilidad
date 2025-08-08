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

  Future<Stage3FormData> _uploadPhotos(
    Stage3FormData data, {
    int batchSize = 4, // <= súbelo/bájalo según red
    int maxRetries = 2, // <= reintentos por foto
    void Function(int done, int total)? onProgress, // opcional
  }) async {
    final uploadImage = ref.read(uploadImageProvider);

    // 1) Preparamos la lista de tareas (manteniendo orden por sequence)
    final baskets = List<BasketWeighData>.from(data.baskets)
      ..sort((a, b) => a.sequence.compareTo(b.sequence));

    final total = baskets.length;
    var done = 0;

    Future<BasketWeighData> uploadOne(BasketWeighData b) async {
      // Si ya es URL => saltar
      final local = b.photoPath;
      if (local.isEmpty || local.startsWith('http')) {
        onProgress?.call(++done, total);
        return b;
      }

      // Reintentos con backoff exponencial suave
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
          final delayMs = 500 * (1 << attempt); // 500ms, 1s, 2s...
          await Future.delayed(Duration(milliseconds: delayMs));
          attempt++;
        }
      }
    }

    // 2) Ejecutamos en tandas (batchSize concurrentes por tanda)
    final updated = <BasketWeighData>[];
    for (var i = 0; i < baskets.length; i += batchSize) {
      final end = (i + batchSize < baskets.length)
          ? i + batchSize
          : baskets.length;
      final chunk = baskets.sublist(i, end);

      final results = await Future.wait(chunk.map(uploadOne));
      updated.addAll(results);
    }

    // 3) Devolvemos data con canastillas actualizadas
    return data.copyWith(baskets: updated);
  }
}
