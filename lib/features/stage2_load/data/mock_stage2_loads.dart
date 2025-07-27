import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

final mockStage2Loads = <Stage2LoadData>[
  // Proyecto p1: dos cargas
  Stage2LoadData(
    id: _uuid.v4(),
    projectId: 'p1',
    date: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
    baskets: BasketLoadData(referenceWeight: 970, count: 22, realWeight: 28),
  ),
  Stage2LoadData(
    id: _uuid.v4(),
    projectId: 'p1',
    date: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
    baskets: BasketLoadData(referenceWeight: 950, count: 30, realWeight: 30),
  ),

  // Proyecto p2: tres cargas
  Stage2LoadData(
    id: _uuid.v4(),
    projectId: 'p2',
    date: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
    baskets: BasketLoadData(referenceWeight: 950, count: 25, realWeight: 29),
  ),
  Stage2LoadData(
    id: _uuid.v4(),
    projectId: 'p2',
    date: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
    baskets: BasketLoadData(referenceWeight: 700, count: 20, realWeight: 20),
  ),
  Stage2LoadData(
    id: _uuid.v4(),
    projectId: 'p2',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    baskets: BasketLoadData(referenceWeight: 950, count: 28, realWeight: 27),
  ),

  // Proyecto p3: una carga
  Stage2LoadData(
    id: _uuid.v4(),
    projectId: 'p3',
    date: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    baskets: BasketLoadData(referenceWeight: 700, count: 30, realWeight: 26),
  ),
];
