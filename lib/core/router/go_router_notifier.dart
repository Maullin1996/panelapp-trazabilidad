import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';

class GoRouterNotifier extends ChangeNotifier {
  final Ref ref;
  late final ProviderSubscription<AuthParams> _sub;

  GoRouterNotifier(this.ref) {
    // 1. Escuchamos authProvider
    _sub = ref.listen<AuthParams>(
      authProvider,
      (previous, next) {
        notifyListeners();
      },
      // Podemos disparar inmediatamente si queremos evaluar de entrada
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
