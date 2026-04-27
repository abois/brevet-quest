import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme_preset.dart';

/// Service singleton qui gère le ThemePreset courant + persistence.
class ThemeService extends ChangeNotifier {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  static const String _kKey = 'theme_preset_id';

  ThemePreset _preset = ThemePreset.violet;
  ThemePreset get preset => _preset;

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString(_kKey);
    if (id != null) _preset = ThemePreset.byId(id);
    notifyListeners();
  }

  Future<void> setPreset(ThemePreset p) async {
    if (_preset.id == p.id) return;
    _preset = p;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, p.id);
  }
}
