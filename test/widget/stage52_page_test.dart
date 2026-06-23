import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:core/features/auth/domain/repositories/auth_repository.dart';
import 'package:core/features/auth/providers/auth_repository_provider.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:core/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:core/features/stage5_2_records/providers/sync_stage52_loads_provider.dart';
import 'package:core/shared/widgets/empty_widget.dart';

import '../../apps/web/lib/feature/stage5/mobile_stage52_page.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

Stage52RecordData _record() => Stage52RecordData(
  id: 'r1',
  projectId: 'p1',
  gaveraWeight: 950,
  panelaWeight: 12,
  unitCount: 3,
  quality: BasketQuality.regular,
  photoPath: '',
  date: DateTime(2024, 1, 1),
);

_baseOverrides({
  List<Stage52RecordData> records = const [],
  required _MockAuthRepository mockAuthRepo,
}) => [
  authRepositoryProvider.overrideWithValue(mockAuthRepo),
  syncStage52LoadsProvider.overrideWith((ref) => records),
  stage52ByProjectProvider.overrideWith((ref, projectId) => records),
  stage52LoadingProvider.overrideWith((ref) => false),
];

void main() {
  late _MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = _MockAuthRepository();
  });

  testWidgets(
    'Stage52Page muestra EmptyWidget y botón crear cuando no hay registros',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: _baseOverrides(mockAuthRepo: mockAuthRepo),
          child: const MaterialApp(home: Stage52Page(projectId: 'p1')),
        ),
      );
      await tester.pump();

      expect(find.byType(EmptyWidget), findsOneWidget);
      expect(
        find.byKey(const Key('stage52-page-form-button')),
        findsOneWidget,
      );
    },
  );

  testWidgets('Stage52Page muestra lista y abre dialog de acciones', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(
          records: [_record()],
          mockAuthRepo: mockAuthRepo,
        ),
        child: const MaterialApp(home: Stage52Page(projectId: 'p1')),
      ),
    );
    await tester.pump();

    expect(find.byType(EmptyWidget), findsNothing);

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text('¿Qué quieres hacer?'), findsOneWidget);
    expect(find.text('Ver resumen'), findsOneWidget);
    expect(find.text('Editar registro'), findsOneWidget);
  });
}
