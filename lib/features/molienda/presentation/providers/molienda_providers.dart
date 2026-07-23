import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/molienda_firestore_datasource.dart';
import '../../data/repositories/molienda_repository_impl.dart';
import '../../domain/entities/molienda.dart';
import '../../domain/entities/entrega.dart';
import '../../domain/repositories/molienda_repository.dart';

part 'molienda_providers.g.dart';

// ── Datasource ─────────────────────────────────────────────────────────────────
@riverpod
MoliendaFirestoreDatasource moliendaDatasource(Ref ref) {
  return MoliendaFirestoreDatasource(firestore: FirebaseFirestore.instance);
}

// ── Repository ─────────────────────────────────────────────────────────────────
@riverpod
MoliendaRepository moliendaRepository(Ref ref) {
  return MoliendaRepositoryImpl(ref.watch(moliendaDatasourceProvider));
}

// ── Watch all ──────────────────────────────────────────────────────────────────
@riverpod
Stream<List<Molienda>> moliendaItems(Ref ref) {
  return ref.watch(moliendaRepositoryProvider).watchAll();
}

// ── Sync (lista sincrónica para usar en dropdowns) ─────────────────────────────
@riverpod
List<Molienda> syncMoliendaItems(Ref ref) {
  return ref
      .watch(moliendaItemsProvider)
      .maybeWhen(data: (data) => data, orElse: () => []);
}

// ── Entregas de una molienda ─────────────────────────────────────────────────────
@riverpod
Stream<List<Entrega>> moliendaEntregas(Ref ref, String moliendaId) {
  return ref.watch(moliendaRepositoryProvider).watchEntregas(moliendaId);
}

// ── Form state ────────────────────────────────────────────────────────────────
enum MoliendaFormStatus { initial, submitting, success, error }

class MoliendaFormState {
  final MoliendaFormStatus status;
  final String? errorMessage;

  const MoliendaFormState({
    this.status = MoliendaFormStatus.initial,
    this.errorMessage,
  });

  static const _undefined = Object();

  MoliendaFormState copyWith({
    MoliendaFormStatus? status,
    Object? errorMessage = _undefined,
  }) {
    return MoliendaFormState(
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _undefined)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

@riverpod
class MoliendaForm extends _$MoliendaForm {
  @override
  MoliendaFormState build() => const MoliendaFormState();

  Future<void> save(Molienda molienda, {required bool isNew}) async {
    state = state.copyWith(status: MoliendaFormStatus.submitting);
    try {
      final repo = ref.read(moliendaRepositoryProvider);
      if (isNew) {
        await repo.create(molienda);
      } else {
        await repo.update(molienda);
      }
      state = state.copyWith(status: MoliendaFormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: MoliendaFormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> delete(String id) async {
    state = state.copyWith(status: MoliendaFormStatus.submitting);
    try {
      await ref.read(moliendaRepositoryProvider).delete(id);
      state = state.copyWith(status: MoliendaFormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: MoliendaFormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createEntrega(Entrega entrega) async {
    state = state.copyWith(status: MoliendaFormStatus.submitting);
    try {
      await ref.read(moliendaRepositoryProvider).createEntrega(entrega);
      state = state.copyWith(status: MoliendaFormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: MoliendaFormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
