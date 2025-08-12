import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:registro_panela/features/auth/domin/repositories/auth_repository.dart';

/// Provider de Riverpod que expone la implementación concreta de [AuthRepository].
///
/// Usado por el notifier `Auth` para acceder a FirebaseAuth y Firestore.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});
