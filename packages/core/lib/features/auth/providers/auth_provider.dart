import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/entities/auth_status.dart';
import '../domain/entities/authenticated_user.dart';
import '../domain/enums/auth_status.dart';
import '../domain/enums/user_role.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_repository_provider.dart';
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
    state = state.copyWith(errorMessage: '');

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
    if (state.authStatus == AuthStatus.authenticated && state.user != null) {
      return;
    }

    try {
      // Espera a que Firebase restaure la sesión — crítico en web
      final user = await FirebaseAuth.instance.authStateChanges().first;

      if (user == null) {
        state = const AuthParams(authStatus: AuthStatus.notAuthenticated);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
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
          id: user.uid,
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
