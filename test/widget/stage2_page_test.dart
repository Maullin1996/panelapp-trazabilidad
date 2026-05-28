import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import '../../packages/core/lib/features/admin/domain/entities/app_user.dart';
import '../../packages/core/lib/features/auth/domain/repositories/auth_repository.dart';
import '../../packages/core/lib/features/auth/presentation/providers/auth_repository_provider.dart';
import '../../packages/core/lib/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import '../../packages/core/lib/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import '../../packages/core/lib/features/stage2_load/domain/entities/stage2_load_data.dart';
import '../../packages/core/lib/features/stage2_load/presentation/stage2_page.dart';
import '../../packages/core/lib/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import '../../packages/core/lib/features/stage2_load/presentation/providers/stage2_loads_error_provider.dart';
import 'package:registro_panela/shared/widgets/empty_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

Stage1FormData _project() => Stage1FormData(
  id: 'p1',
  name: 'Molienda',
  gaveras: const [GaveraData(quantity: 2, referenceWeight: 950)],
  basketsQuantity: 10,
  preservativesWeight: 1,
  preservativesJars: 1,
  limeWeight: 1,
  limeJars: 1,
  phone: '1234567',
  date: DateTime(2024, 1, 1),
);

Stage2LoadData _load() => Stage2LoadData(
  id: 'l1',
  projectId: 'p1',
  date: DateTime(2024, 1, 2),
  baskets: const BasketLoadData(referenceWeight: 950, count: 5, realWeight: 12),
);

// Estado de auth sin Firebase
class FakeAuthState {
  // Ajusta según tu AuthState — usuario nulo = sin permisos de admin
  AppUser? get user => null;
}

void main() {
  final mockAuthRepo = MockAuthRepository();
  // Override base que todos los tests necesitan
  List<Override> baseOverrides({List<Stage2LoadData> loads = const []}) => [
    stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
    syncStage2ProjectsProvider.overrideWith((ref) => loads),
    stage2LoadsErrorProvider.overrideWith((ref) => null),
    authRepositoryProvider.overrideWithValue(mockAuthRepo),
  ];

  testWidgets('Stage2Page muestra EmptyWidget cuando no hay cargues', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: baseOverrides(),
        child: const MaterialApp(home: Stage2Page(projectId: 'p1')),
      ),
    );
    expect(find.byType(EmptyWidget), findsOneWidget);
    expect(
      find.byKey(const Key('stage2-page-create-load-button')),
      findsOneWidget,
    );
  });

  testWidgets('Stage2Page renderiza la card de un cargue', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: baseOverrides(loads: [_load()]),
        child: const MaterialApp(home: Stage2Page(projectId: 'p1')),
      ),
    );

    expect(
      find.byKey(const Key('stage2-page-load-custom-card-l1')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('stage2_page_12.0-weight')), findsOneWidget);

    await tester.tap(find.byKey(const Key('stage2-page-load-custom-card-l1')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('stage2-page-edit-textbutton')),
      findsOneWidget,
    );
  });
}
