import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  focusColor: Colors.transparent,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFE7E5),
    primary: Color(0xFFFF6961),
  ),
  textTheme: const TextTheme(),
  fontFamily: 'Roboto',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      backgroundColor: const WidgetStatePropertyAll<Color?>(null),
      foregroundColor: const WidgetStatePropertyAll<Color?>(null),
      shadowColor: const WidgetStatePropertyAll<Color?>(null),
      elevation: const WidgetStatePropertyAll<double?>(null),
      side: const WidgetStatePropertyAll<BorderSide?>(null),
      shape: const WidgetStatePropertyAll<RoundedRectangleBorder?>(null),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  ),
);

@NowaGenerated()
final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(),
  textTheme: const TextTheme(),
);
