import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/stage51_notifier_provider.dart';

final syncStage51PaymentsProvider = Provider((ref) {
  final asyncProjects = ref.watch(stage51NotifierProvider);
  return asyncProjects.maybeWhen(
    data: (data) => data,
    orElse: () => <PaymentData>[],
  );
});
