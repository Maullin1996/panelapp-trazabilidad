import 'package:registro_panela/features/stage2_load/data/mock_stage2_loads.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

final mockStage3Entries = <Stage3FormData>[
  for (final load in mockStage2Loads)
    Stage3FormData(
      id: _uuid.v4(),
      projectId: load.projectId,
      stage2LoadId: load.id,
      date: load.date.add(const Duration(hours: 2)),
      baskets: [
        // imaginemos que siempre falta 1 canastilla
        for (int i = 0; i < load.baskets.count - 1; i++)
          BasketWeighData(
            id: _uuid.v4(),
            sequence: i,
            referenceWeight: load.baskets.referenceWeight,
            realWeight:
                load.baskets.realWeight +
                (i.isEven ? 0.0 : -0.5), // variación de ejemplo
            quality: i % 2 == 0 ? BasketQuality.buena : BasketQuality.regular,
            photoPath: '',
          ),
      ],
    ),
];
