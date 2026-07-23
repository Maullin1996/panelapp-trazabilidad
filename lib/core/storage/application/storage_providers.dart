import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/firebase_storage_datasource.dart';
import '../data/repositories_impl/storage_repository_impl.dart';
import '../domain/repositories/storage_repository.dart';
import '../domain/usecases/upload_image.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepositoryImpl(FirebaseStorageDatasource());
});

final uploadImageProvider = Provider<UploadImage>((ref) {
  return UploadImage(ref.read(storageRepositoryProvider));
});
