import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference { system, light, dark }

class AppThemeController extends ChangeNotifier {
  AppThemeController._();

  static const _modeKey = 'app_theme_mode';
  static const _accentKey = 'app_accent_color';
  static const _densityKey = 'app_compact_density';

  static final AppThemeController instance = AppThemeController._();

  AppThemePreference _preference = AppThemePreference.system;
  Color _accent = const Color(0xFF0879B8);
  bool _compactDensity = false;
  bool _initialized = false;

  AppThemePreference get preference => _preference;
  Color get accent => _accent;
  bool get compactDensity => _compactDensity;
  bool get initialized => _initialized;

  ThemeMode get themeMode => switch (_preference) {
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
      };

  Future<void> initialize() async {
    if (_initialized) return;
    final preferences = await SharedPreferences.getInstance();
    final storedMode = preferences.getString(_modeKey);
    _preference = AppThemePreference.values.firstWhere(
      (item) => item.name == storedMode,
      orElse: () => AppThemePreference.system,
    );
    final accentValue = preferences.getInt(_accentKey);
    if (accentValue != null) _accent = Color(accentValue);
    _compactDensity = preferences.getBool(_densityKey) ?? false;
    _initialized = true;
    notifyListeners();
  }

  Future<void> setPreference(AppThemePreference preference) async {
    if (_preference == preference) return;
    _preference = preference;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_modeKey, preference.name);
  }

  Future<void> setAccent(Color accent) async {
    if (_accent == accent) return;
    _accent = accent;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_accentKey, accent.toARGB32());
  }

  Future<void> setCompactDensity(bool enabled) async {
    if (_compactDensity == enabled) return;
    _compactDensity = enabled;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_densityKey, enabled);
  }

  ThemeData buildTheme({
    required Brightness brightness,
    required String fontFamily,
    required Iterable<String> fontFallback,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: brightness,
    );
    final dark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          dark ? const Color(0xFF0D141A) : const Color(0xFFF3F7FA),
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback.toList(),
      visualDensity: _compactDensity
          ? VisualDensity.compact
          : VisualDensity.standard,
      cardTheme: CardThemeData(
        elevation: 0,
        color: dark ? const Color(0xFF172129) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: dark
                ? Colors.white.withValues(alpha: .08)
                : const Color(0xFFE4ECF1),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: dark ? const Color(0xFF172129) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark
            ? Colors.white.withValues(alpha: .06)
            : const Color(0xFFF7FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: dark
                ? Colors.white.withValues(alpha: .08)
                : const Color(0xFFE4ECF1),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: _compactDensity ? 16 : 20,
            vertical: _compactDensity ? 12 : 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
