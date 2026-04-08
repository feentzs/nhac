import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFE7E5),
    primary: Color(0xFFFF6961),
  ),
  textTheme: const TextTheme(),
  fontFamily: 'Roboto',
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color?>(null),
      foregroundColor: WidgetStatePropertyAll<Color?>(null),
      shadowColor: WidgetStatePropertyAll<Color?>(null),
      elevation: WidgetStatePropertyAll<double?>(null),
      side: WidgetStatePropertyAll<BorderSide?>(null),
      shape: WidgetStatePropertyAll<RoundedRectangleBorder?>(null),
    ),
  ),
);

@NowaGenerated()
final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(),
  textTheme: const TextTheme(),
);
