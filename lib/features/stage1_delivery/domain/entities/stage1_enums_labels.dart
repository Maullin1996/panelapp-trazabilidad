import 'stage1_form_data.dart';

extension BasketSizeLabel on BasketSize {
  String get label => switch (this) {
    BasketSize.grande => 'Grande',
    BasketSize.pequena => 'Pequeña',
  };
}
