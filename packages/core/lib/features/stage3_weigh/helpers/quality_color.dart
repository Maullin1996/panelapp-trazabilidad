import 'package:flutter/material.dart';
import '../../../shared/utils/colors.dart';

Color qualityColor({required String quality}) {
  switch (quality) {
    case 'Negra':
      return AppColors.textDark;
    case 'Regular':
      return AppColors.alert;
    case 'Buena':
      return AppColors.accepted;
    default:
      return AppColors.error;
  }
}
