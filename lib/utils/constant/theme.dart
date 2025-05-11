import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Color(0xffffffff),
  colorScheme: lightColorScheme,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff407CE2),
  surfaceTint: Color(0xff0d6680),
  onPrimary: Color(0xffffffff), // white
  primaryContainer: Color(0xFFEBFEFF),
  onPrimaryContainer: Color(0xff211B69),
  secondary: Color(0xff0b7aa1),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffF5F6FF),
  onSecondaryContainer: Color(0xff5B0D80),
  tertiary: Color(0xffdaffe8),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffe2dfff),
  onTertiaryContainer: Color(0xff181837),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff410002),
  surface: Color(0xfff5fafd),
  onSurface: Color(0xff171c1f), // black text
  onSurfaceVariant: Color(0xff333333),
  outline: Color(0xff70787d), // border color, hint text
  outlineVariant: Color(0xffc0c8cc), // box shadow
  shadow: Color(0x668C8B8B),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2c3134),
  inversePrimary: Color(0xff89d0ee),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff89d0ee),
  surfaceTint: Color(0xff89d0ee),
  onPrimary: Color(0xff003545),
  primaryContainer: Color(0xff004d62),
  onPrimaryContainer: Color(0xffbaeaff),
  secondary: Color(0xffb4cad5),
  onSecondary: Color(0xff1e333c),
  secondaryContainer: Color(0xff354a53),
  onSecondaryContainer: Color(0xffcfe6f1),
  tertiary: Color(0xffc5c3ea),
  onTertiary: Color(0xff2d2d4d),
  tertiaryContainer: Color(0xff444465),
  onTertiaryContainer: Color(0xffe2dfff),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffdad6),
  surface: Color(0xff0f1417),
  onSurface: Color(0xffdee3e6),
  onSurfaceVariant: Color(0xffc0c8cc),
  outline: Color(0xff8a9296),
  outlineVariant: Color(0xff40484c),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffdee3e6),
  inversePrimary: Color(0xff0d6680),
);
