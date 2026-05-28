import '../datasource/stage51_payment_datasource.dart';
import '../models/stage51_payment_data_model.dart';
import '../../domain/entities/payment_data.dart';
import '../../domain/repositories/stage51_repository.dart';

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
  Stream<List<PaymentData>> watch() {
    return datasource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
