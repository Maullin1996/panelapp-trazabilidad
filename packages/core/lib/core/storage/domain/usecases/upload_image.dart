import 'dart:typed_data';
import '../repositories/storage_repository.dart';

class UploadImage {
  final StorageRepository repository;
  UploadImage(this.repository);

  Future<String> call({required String path, required Uint8List bytes}) {
    return repository.uploadImage(path: path, bytes: bytes);
  }
}
