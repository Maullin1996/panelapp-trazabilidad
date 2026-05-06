import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_panela/features/auth/domin/repositories/auth_repository.dart';
import 'package:registro_panela/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/stage52_page.dart';
import 'package:registro_panela/shared/widgets/empty_widget.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

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

void main() {
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
  });

  testWidgets('Stage52Page muestra lista y acciones del dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo), // ✅
          syncStage52LoadsProvider.overrideWith((ref) => [_record()]),
        ],
        child: const MaterialApp(home: Stage52Page(projectId: 'p1')),
      ),
    );

    expect(find.text('Registros'), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text('¿Qué quieres hacer?'), findsOneWidget);
    expect(find.text('Ver resumen'), findsOneWidget);
    expect(find.text('Editar registro'), findsOneWidget);
  });

  testWidgets(
    'Stage52Page muestra EmptyWidget y botón crear cuando no hay registros',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepo), // ✅
            syncStage52LoadsProvider.overrideWith((ref) => const []),
          ],
          child: const MaterialApp(home: Stage52Page(projectId: 'p1')),
        ),
      );

      expect(find.byType(EmptyWidget), findsOneWidget);
      expect(find.byKey(const Key('stage52-page-form-button')), findsOneWidget);
    },
  );
}
