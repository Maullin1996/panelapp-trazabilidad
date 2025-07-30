import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Verificar auth
      await ref.read(authProvider.notifier).checkAuthStatus();
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final textTheme = TextTheme.of(context);

    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (next.authStatus != AuthStatus.checking) {}
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, size: 80, color: AppColors.textDark),
              const SizedBox(height: 24),
              Text('Registro Panela', style: textTheme.headlineLarge),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textDark),
              ),
              const SizedBox(height: 16),
              Text(
                _getLoadingMessage(authState.authStatus),
                style: const TextStyle(color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLoadingMessage(AuthStatus status) {
    switch (status) {
      case AuthStatus.checking:
        return 'Verificando sesión...';
      case AuthStatus.authenticated:
        return 'Iniciando aplicación...';
      case AuthStatus.notAuthenticated:
        return 'Cargando...';
    }
  }
}
