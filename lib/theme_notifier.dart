import 'package:flutter/material.dart';

/// Global dark mode state. Import this in main.dart and settings.dart.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
