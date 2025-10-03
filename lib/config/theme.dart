import 'package:flutter/material.dart';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5D5FEF)),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}
