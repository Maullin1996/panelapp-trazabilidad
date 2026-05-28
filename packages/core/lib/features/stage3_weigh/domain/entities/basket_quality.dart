import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum BasketQuality {
  @JsonValue('regular')
  regular,
  @JsonValue('buena')
  buena,
  @JsonValue('negra')
  negra,
  @JsonValue('extra')
  extra,
}
