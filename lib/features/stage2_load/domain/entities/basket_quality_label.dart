import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';

extension BasketQualityLabel on BasketQuality {
  String get label => switch (this) {
    BasketQuality.regular => 'Regular',
    BasketQuality.buena => 'Buena',
    BasketQuality.negra => 'Negra',
    BasketQuality.extra => 'Extra',
  };
}
