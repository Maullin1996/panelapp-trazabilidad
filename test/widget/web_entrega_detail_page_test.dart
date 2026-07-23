import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:registro_panela/features/molienda/domain/entities/entrega.dart';
import 'package:registro_panela/features/molienda/presentation/providers/molienda_providers.dart';

import 'package:registro_panela/features/molienda/presentation/pages/web_entrega_detail_page.dart';

void main() {
  final tFechaEntrega = DateTime(2026, 3, 2, 14, 0);

  final tEntrega = Entrega(
    id: 'entrega-1',
    moliendaId: 'molienda-1',
    produccionId: 'lote-1',
    fechaEntrega: tFechaEntrega,
    qrToken: 'qr-token-1',
  );

  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/entrega',
      routes: [
        GoRoute(
          path: '/entrega',
          builder: (context, state) => const WebEntregaDetailPage(
            moliendaId: 'molienda-1',
            entregaId: 'entrega-1',
          ),
        ),
        GoRoute(
          name: 'loteDetail',
          path: '/lote/:produccionId',
          builder: (context, state) {
            final produccionId = state.pathParameters['produccionId']!;
            return Scaffold(body: Text('Lote: $produccionId'));
          },
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        moliendaEntregasProvider.overrideWith(
          (ref, moliendaId) => Stream.value([tEntrega]),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('WebEntregaDetailPage muestra el QR y la fecha de entrega', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.byType(QrImageView), findsOneWidget);
    expect(
      find.text(DateFormat('dd/MM/yyyy HH:mm').format(tFechaEntrega)),
      findsOneWidget,
    );
  });

  testWidgets(
    'WebEntregaDetailPage el botón Ver lote navega a la vista del lote',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.text('Ver lote'));
      await tester.pumpAndSettle();

      expect(find.text('Lote: lote-1'), findsOneWidget);
    },
  );
}
