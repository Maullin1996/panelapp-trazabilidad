//stage5_price_per_kilo_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage51_price_per_kilo_provider.g.dart';

@riverpod
class Stage5PricePerKilo extends _$Stage5PricePerKilo {
  @override
  double? build(String projectId) => null;

  void setPrice(double price) => state = price;
  void clear() => state = null;
}
