import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/core/router/app_router.dart';
import 'package:registro_panela/shared/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await initializeDateFormatting('es', null);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Registro Panela',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
    );
  }
}
