import 'package:flutter/material.dart';
import 'package:flutter_enercent/constants.dart';

ThemeData theme() {
  return ThemeData(
    elevatedButtonTheme: elevatedButtonTheme(),
  );
}

ElevatedButtonThemeData elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      textStyle: const TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius)),
      minimumSize: const Size(buttonWidth,0)
    )
  );
}
