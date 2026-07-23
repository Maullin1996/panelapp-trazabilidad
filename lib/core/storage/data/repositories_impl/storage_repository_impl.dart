import 'dart:typed_data';
import '../datasource/firebase_storage_datasource.dart';
import '../../domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final FirebaseStorageDatasource datasource;
  StorageRepositoryImpl(this.datasource);

  @override
  Future<String> uploadImage({required String path, required Uint8List bytes}) {
    return datasource.uploadImage(path: path, bytes: bytes);
  }
}
