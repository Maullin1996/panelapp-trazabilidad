import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget web;
  final double breakpoint;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    required this.web,
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width < breakpoint ? mobile : web;
  }
}
