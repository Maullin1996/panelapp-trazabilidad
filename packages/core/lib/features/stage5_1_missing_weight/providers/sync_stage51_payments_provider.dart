import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/payment_data.dart';
import 'stage51_notifier_provider.dart';

final syncStage51PaymentsProvider = Provider((ref) {
  final asyncProjects = ref.watch(stage51Provider);
  return asyncProjects.maybeWhen(
    data: (data) => data,
    orElse: () => <PaymentData>[],
  );
});
