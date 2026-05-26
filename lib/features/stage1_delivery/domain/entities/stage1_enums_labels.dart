import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';

extension GaveraTypeLabel on GaveraType {
  String get label => switch (this) {
    GaveraType.kilo => 'Kilo',
    GaveraType.redonda => 'Redonda',
    GaveraType.panelon => 'Panelon',
    GaveraType.pacha => 'Pacha',
    GaveraType.pastilla => 'Pastilla',
  };
}

extension BasketSizeLabel on BasketSize {
  String get label => switch (this) {
    BasketSize.grande => 'Grande',
    BasketSize.pequena => 'Pequeña',
  };
}
