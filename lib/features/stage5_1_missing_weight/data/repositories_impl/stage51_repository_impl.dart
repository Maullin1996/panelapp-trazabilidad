import 'package:registro_panela/features/stage5_1_missing_weight/data/datasource/stage51_payment_datasource.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/data/models/stage51_payment_data_model.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';

class Stage51RepositoryImpl implements Stage51Repository {
  final Stage51PaymentDatasource datasource;

  Stage51RepositoryImpl(this.datasource);

  @override
  Future<void> create(PaymentData data) {
    final model = PaymentDataModel.fromEntity(data);
    return datasource.create(model);
  }

  @override
  Future<void> delete(String id) {
    return datasource.delete(id);
  }

  @override
  Future<List<PaymentData>> getAll() async {
    final models = await datasource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Stream<List<PaymentData>> watch() {
    return datasource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
