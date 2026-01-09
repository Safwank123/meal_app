import 'package:flutter/material.dart';
import 'package:meal_app/main.dart';

abstract class AppColors {
  static BuildContext? get _context => navigatorKey.currentContext;

  static ColorScheme get _colorScheme =>
      _context != null
          ? Theme.of(_context!).colorScheme
          : const ColorScheme.light();

  static Color get kAppPrimary => _colorScheme.primary;
  static Color get kAppSecondary => _colorScheme.secondary;
  static Color get kAppOnPrimary => _colorScheme.onPrimary;
  static Color get kAppOnSecondary => _colorScheme.onSecondary;
  static Color get kAppOnSurface => _colorScheme.onSurface;
  static Color get kAppError => _colorScheme.error;
  static Color get kAppShadow => _colorScheme.shadow;

  static Color get kAppScaffold =>
      _context != null ? Theme.of(_context!).scaffoldBackgroundColor : Colors.white;

  static Color get kAppDisabled =>
      _context != null ? Theme.of(_context!).disabledColor : Colors.grey;

  static const Color kAppWhite = Color(0xFFFFFFFF);
  static const Color kAppBlack = Color(0xFF000000);
  static const Color kAppSuccess = Color(0xFF2E7D32);
  static const Color kAppWarning = Color(0xFFD84315);
  static const Color kAppInfo = Color(0xFF1565C0);
}
