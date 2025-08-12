import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/entities/authenticated_user.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import 'package:registro_panela/features/auth/domin/repositories/auth_repository.dart';
import 'package:registro_panela/features/auth/providers/auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Notifier de autenticación con Riverpod (keepAlive).
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthRepository _authRepository;

  /// Estado inicial: `checking` (validando sesión previa).
  @override
  AuthParams build() {
    _authRepository = ref.read(authRepositoryProvider);
    return const AuthParams();
  }

  /// Login con email/clave. Actualiza [state] según resultado.
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(authStatus: AuthStatus.checking, errorMessage: '');

    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      state = state.copyWith(
        user: user,
        authStatus: AuthStatus.authenticated,
        errorMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  /// Cierra sesión y limpia el estado.
  Future<void> logout() async {
    await _authRepository.signOut();
    state = const AuthParams(authStatus: AuthStatus.notAuthenticated);
  }

  /// Verifica sesión al inicio (splash) o reingreso a la app.
  Future<void> checkAuthStatus() async {
    // Si ya estamos autenticados, no rehacer la carga.
    if (state.authStatus == AuthStatus.authenticated && state.user != null) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const AuthParams(authStatus: AuthStatus.notAuthenticated);
        return;
      }
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (!doc.exists) {
        state = const AuthParams(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Usuario sin perfil en Firestore',
        );
        return;
      }

      final data = doc.data()!;
      final role = UserRole.values.firstWhere(
        (it) => it.name == data['role'],
        orElse: () => UserRole.stage1,
      );

      state = state.copyWith(
        user: AuthenticatedUser(
          id: uid,
          name: data['name'],
          email: data['email'],
          role: role,
          token: await user.getIdToken() ?? '',
        ),
        authStatus: AuthStatus.authenticated,
      );
    } catch (e) {
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: 'Error al verificar sesión: ${e.toString()}',
      );
    }
  }
}
