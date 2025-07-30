import 'package:registro_panela/features/auth/domin/entities/authenticated_user.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';

class AuthParams {
  final AuthenticatedUser? user;
  final AuthStatus authStatus;
  final String? errorMessage;

  const AuthParams({
    this.user,
    this.authStatus = AuthStatus.checking,
    this.errorMessage,
  });

  AuthParams copyWith({
    AuthenticatedUser? user,
    AuthStatus? authStatus,
    String? errorMessage,
  }) {
    return AuthParams(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
