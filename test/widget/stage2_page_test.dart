import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:registro_panela/features/auth/domain/repositories/auth_repository.dart';
import 'package:registro_panela/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:registro_panela/shared/widgets/empty_widget.dart';

import 'package:registro_panela/features/stage2_load/presentation/pages/mobile_stage2_page.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

Stage1FormData _project() => Stage1FormData(
  id: 'p1',
  name: 'Molienda',
  gaveras: const [GaveraData(quantity: 2, referenceWeight: 950)],
  baskets: const [],
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
  baskets: const BasketLoadData(
    referenceWeight: 950,
    count: 5,
    quality: BasketQuality.buena,
  ),
);

_baseOverrides({
  List<Stage2LoadData> loads = const [],
  _MockAuthRepository? mockAuthRepo,
}) => [
  stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
  syncStage2ProjectsProvider.overrideWith((ref) => loads),
  stage2LoadsErrorProvider.overrideWith((ref) => null),
  stage2ProjectsLoadingProvider.overrideWith((ref) => false),
  if (mockAuthRepo != null)
    authRepositoryProvider.overrideWithValue(mockAuthRepo),
];

void main() {
  late _MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = _MockAuthRepository();
  });

  testWidgets('Stage2Page muestra EmptyWidget cuando no hay cargues', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(mockAuthRepo: mockAuthRepo),
        child: const MaterialApp(home: Stage2Page(projectId: 'p1')),
      ),
    );
    await tester.pump();

    expect(find.byType(EmptyWidget), findsOneWidget);
    expect(
      find.byKey(const Key('stage2-page-create-load-button')),
      findsOneWidget,
    );
  });

  testWidgets('Stage2Page renderiza la card de un cargue', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(loads: [_load()], mockAuthRepo: mockAuthRepo),
        child: const MaterialApp(home: Stage2Page(projectId: 'p1')),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const Key('stage2-page-load-custom-card-l1')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('stage2_page_buena-quality')), findsOneWidget);
  });

  testWidgets('Stage2Page abre dialog al tocar una card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(loads: [_load()], mockAuthRepo: mockAuthRepo),
        child: const MaterialApp(home: Stage2Page(projectId: 'p1')),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('stage2-page-load-custom-card-l1')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('stage2-page-edit-textbutton')),
      findsOneWidget,
    );
  });
}
