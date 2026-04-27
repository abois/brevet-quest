import 'package:flutter/widgets.dart';

import '../services/theme_service.dart';
import 'theme_preset.dart';

/// Diffuse le ThemeService dans l'arbre via un InheritedNotifier.
/// Chaque widget qui appelle `ThemeScope.of(context)` (au moins une
/// fois dans son build) sera reconstruit dès que ThemeService notifie —
/// y compris les écrans pushés via Navigator.
class ThemeScope extends InheritedNotifier<ThemeService> {
  ThemeScope({super.key, required super.child})
      : super(notifier: ThemeService.instance);

  /// Inscrit le widget appelant aux notifications du ThemeService et
  /// retourne le preset courant.
  static ThemePreset of(BuildContext context) {
    final ThemeScope? scope =
        context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    return scope?.notifier?.preset ?? ThemeService.instance.preset;
  }
}
