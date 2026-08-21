import 'package:flutter/material.dart';

/// Corner radius tokens defined in DESIGN.md.
class AppRadius {
  AppRadius._();

  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double pill = 999.0;

  static const BorderRadius smallBorderRadius = BorderRadius.all(Radius.circular(small));
  static const BorderRadius mediumBorderRadius = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeBorderRadius = BorderRadius.all(Radius.circular(large));
  static const BorderRadius pillBorderRadius = BorderRadius.all(Radius.circular(pill));
}
