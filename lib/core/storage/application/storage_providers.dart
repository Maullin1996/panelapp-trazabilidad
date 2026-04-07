import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/core/storage/data/datasource/firebase_storage_datasource.dart';
import 'package:registro_panela/core/storage/data/repositories_impl/storage_repository_impl.dart';
import 'package:registro_panela/core/storage/domain/repositories/storage_repository.dart';
import 'package:registro_panela/core/storage/domain/usecases/upload_image.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepositoryImpl(FirebaseStorageDatasource());
});

final uploadImageProvider = Provider<UploadImage>((ref) {
  return UploadImage(ref.read(storageRepositoryProvider));
});
