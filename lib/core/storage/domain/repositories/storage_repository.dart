import 'dart:typed_data';

abstract class StorageRepository {
  Future<String> uploadImage({required String path, required Uint8List bytes});
}
