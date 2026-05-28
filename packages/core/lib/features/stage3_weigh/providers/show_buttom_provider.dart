import 'package:riverpod_annotation/riverpod_annotation.dart';

part "show_buttom_provider.g.dart";

@riverpod
class ShowButtom extends _$ShowButtom {
  @override
  bool build() => false;

  void showButton(bool buttonStatus) {
    state = buttonStatus;
  }
}
