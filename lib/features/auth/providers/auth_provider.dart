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

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthRepository _authRepository;
  @override
  AuthParams build() {
    _authRepository = ref.read(authRepositoryProvider);
    return const AuthParams();
  }

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

  Future<void> logout() async {
    await _authRepository.signOut();
    state = const AuthParams(authStatus: AuthStatus.notAuthenticated);
  }

  Future<void> checkAuthStatus() async {
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
        (user) => user.name == data['role'],
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
