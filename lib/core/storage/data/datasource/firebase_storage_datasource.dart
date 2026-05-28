import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDatasource {
  final FirebaseStorage _storage;

  FirebaseStorageDatasource({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await uploadTask.ref.getDownloadURL();
  }
}
