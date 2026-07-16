import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:core/features/molienda/domain/entities/entrega.dart';
import 'package:core/features/molienda/providers/molienda_providers.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage1_delivery/providers/index.dart';

import '../../apps/web/lib/feature/molienda/web_lote_detail_page.dart';

void main() {
  final tDate = DateTime(2026, 3, 1, 9, 30);
  final tFechaEntrega = DateTime(2026, 3, 2, 14, 0);

  final tStage1Data = Stage1FormData(
    id: 'lote-1',
    name: 'Molienda El Paraíso',
    moliendaId: 'molienda-1',
    gaveras: const [],
    baskets: const [],
    preservativesWeight: 0,
    preservativesJars: 0,
    limeWeight: 0,
    limeJars: 0,
    phone: '3000000000',
    date: tDate,
  );

  final tEntrega = Entrega(
    id: 'entrega-1',
    moliendaId: 'molienda-1',
    produccionId: 'lote-1',
    fechaEntrega: tFechaEntrega,
    qrToken: 'qr-token-1',
  );

  testWidgets('WebLoteDetailPage muestra el nombre de la molienda y la fecha', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdRemoteProvider.overrideWith(
            (ref, id) => tStage1Data,
          ),
          moliendaEntregasProvider.overrideWith(
            (ref, moliendaId) => Stream.value([tEntrega]),
          ),
        ],
        child: const MaterialApp(
          home: WebLoteDetailPage(produccionId: 'lote-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Molienda El Paraíso', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        DateFormat('dd/MM/yyyy HH:mm').format(tFechaEntrega),
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('WebLoteDetailPage muestra loading mientras carga', (
    tester,
  ) async {
    final completer = Completer<Stage1FormData?>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdRemoteProvider.overrideWith(
            (ref, id) => completer.future,
          ),
        ],
        child: const MaterialApp(
          home: WebLoteDetailPage(produccionId: 'lote-1'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('WebLoteDetailPage muestra mensaje cuando no encuentra el lote', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdRemoteProvider.overrideWith((ref, id) => null),
        ],
        child: const MaterialApp(
          home: WebLoteDetailPage(produccionId: 'no-existe'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Lote no encontrado'), findsOneWidget);
  });
}
