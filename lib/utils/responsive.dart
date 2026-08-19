import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? bigTablet;
  final Widget desktop;
  final Widget? largeDesktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.bigTablet,
    required this.desktop,
    this.largeDesktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;

  static bool isBigTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200 &&
      MediaQuery.of(context).size.width < 1600;
      
  static bool isExtraLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1600;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width >= 1600 && largeDesktop != null) {
      return largeDesktop!;
    } else if (width >= 1200) {
      return desktop;
    } else if (width >= 900 && bigTablet != null) {
      return bigTablet!;
    } else if (width >= 600 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
