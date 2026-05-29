import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';

extension BasketQualityLabel on BasketQuality {
  String get label => switch (this) {
    BasketQuality.regular => 'Regular',
    BasketQuality.buena => 'Buena',
    BasketQuality.negra => 'Negra',
    BasketQuality.extra => 'Extra',
  };
}
