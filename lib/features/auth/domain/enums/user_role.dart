import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('stage1')
  stage1,
  @JsonValue('stage2')
  stage2,
  @JsonValue('stage3')
  stage3,
  @JsonValue('stage4')
  stage4,
  @JsonValue('stage5')
  stage5,
}
