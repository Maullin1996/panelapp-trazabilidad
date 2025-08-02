import 'package:registro_panela/core/storage/application/storage_providers.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/providers/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage1_form_provider.g.dart';

enum Stage1FormStatus { initial, submitting, success, error }

@riverpod
class Stage1Form extends _$Stage1Form {
  @override
  Stage1FormState build() => const Stage1FormState();

  Future<void> submit(Stage1FormData data, {required bool isNew}) async {
    state = state.copyWith(status: Stage1FormStatus.submitting);

    try {
      if (data.photoPath != null &&
          data.photoPath!.isNotEmpty &&
          !data.photoPath!.startsWith('http')) {
        final uploadImage = ref.read(uploadImageProvider);
        final downloadUrl = await uploadImage(
          path: 'stage1_photos/${data.id}.jpg',
          localFilePath: data.photoPath!,
        );
        data = data.copyWith(photoPath: downloadUrl);
      }
      if (isNew) {
        final createUseCase = ref.read(createStage1DataProvider);
        await createUseCase(data);

        final notifier = ref.read(stage1ProjectsProvider.notifier);
        notifier.refresh();
      } else {
        final updateUseCase = ref.read(updateStage1DataProvider);
        await updateUseCase(data);
        final notifier = ref.read(stage1ProjectsProvider.notifier);
        notifier.refresh();
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
