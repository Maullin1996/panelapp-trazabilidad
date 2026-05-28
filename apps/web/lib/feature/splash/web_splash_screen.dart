import 'package:flutter/material.dart';
import 'package:core/shared/utils/tokens.dart';

class WebSplashScreen extends StatelessWidget {
  const WebSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      body: Center(child: Image.asset('assets/images/logo.png', width: 200)),
    );
  }
}
