import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';

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

      // Pequeño delay para UX (opcional)
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (next.authStatus != AuthStatus.checking) {}
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Registro Panela',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                _getLoadingMessage(authState.authStatus),
                style: const TextStyle(color: Colors.white70),
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
