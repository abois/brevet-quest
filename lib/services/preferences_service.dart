import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chapter.dart';

/// Préférences utilisateur globales (niveau de programme, etc.).
class PreferencesService extends ChangeNotifier {
  PreferencesService._();

  static final PreferencesService instance = PreferencesService._();

  static const String _kNiveau = 'pref_niveau_id';

  Niveau _niveau = Niveau.all;
  Niveau get niveau => _niveau;

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString(_kNiveau);
    if (id != null) _niveau = NiveauX.fromId(id);
    notifyListeners();
  }

  Future<void> setNiveau(Niveau n) async {
    if (_niveau == n) return;
    _niveau = n;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNiveau, n.id);
  }
}
