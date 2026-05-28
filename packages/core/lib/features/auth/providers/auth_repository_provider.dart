import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';

/// Provider de Riverpod que expone la implementación concreta de [AuthRepository].
///
/// Usado por el notifier `Auth` para acceder a FirebaseAuth y Firestore.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});
