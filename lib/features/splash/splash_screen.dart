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
    // Dispara pero no bloquees la UI
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(Duration(milliseconds: 1000));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (next.authStatus != AuthStatus.checking) {
        ref.read(authProvider.notifier).checkAuthStatus();
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.agriculture,
                size: 80,
                color: AppColors.textDark,
              ),
              const SizedBox(height: 24),
              Text('Registro Panela', style: textTheme.headlineLarge),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textDark),
              ),
              const SizedBox(height: 16),
              Text(
                'Verificando sesión...',
                style: const TextStyle(color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
