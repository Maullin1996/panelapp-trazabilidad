import 'package:registro_panela/features/stage1_delivery/data/models/stage1_form_model.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_ui_state.dart';
import 'package:uuid/uuid.dart';

int _toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

/// Construye la entrega **delta** (solo lo que el usuario ingresó hoy).
/// Devuelve null si todos los campos son 0 (no hay cambios).
Stage4FormData? buildDeltaOrNull({
  required Stage1FormModel project, // o tu entidad Project
  required Stage4UiState totals, // acumulados ya devueltos
  required Map<String, dynamic> vals, // _formKey.currentState!.value
  required String projectId,
}) {
  bool any = false;

  // Gaveras
  final gaveras = <ReturnedGaveras>[];
  for (int i = 0; i < project.gaveras.length; i++) {
    final supplied = project.gaveras[i]['quantity'] as int;
    final returned = totals.returnedGaveras[i].quantity;
    final remaining = (supplied - returned).clamp(0, supplied);
    final entered = _toInt(vals['returnGavera_$i']);
    final today = entered.clamp(0, remaining);

    if (today > 0) any = true;
    gaveras.add(
      ReturnedGaveras(
        quantity: today,
        referenceWeight: (project.gaveras[i]['referenceWeight'] as num)
            .toDouble(),
      ),
    );
  }

  // Canastillas
  final basketsRemaining = (project.basketsQuantity - totals.returnedBaskets)
      .clamp(0, project.basketsQuantity);
  final basketsToday = _toInt(vals['returnBaskets']).clamp(0, basketsRemaining);
  if (basketsToday > 0) any = true;

  // Conservantes (tarros)
  final preservRemaining =
      (project.preservativesJars - totals.returnedPreservativesJars).clamp(
        0,
        project.preservativesJars,
      );
  final preservToday = _toInt(
    vals['returnPreservativesJars'],
  ).clamp(0, preservRemaining);
  if (preservToday > 0) any = true;

  // Cal (tarros)
  final limeRemaining = (project.limeJars - totals.returnedLimeJars).clamp(
    0,
    project.limeJars,
  );
  final limeToday = _toInt(vals['returnLimeJars']).clamp(0, limeRemaining);
  if (limeToday > 0) any = true;

  if (!any) return null;

  return Stage4FormData(
    id: const Uuid().v4(),
    projectId: projectId,
    date: DateTime.now(),
    returnedGaveras: gaveras,
    returnedBaskets: basketsToday,
    returnedPreservativesJars: preservToday,
    returnedLimeJars: limeToday,
  );
}
