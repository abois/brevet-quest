import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'services/preferences_service.dart';
import 'services/progress_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await ProgressService.instance.load();
  await ThemeService.instance.load();
  await PreferencesService.instance.load();
  await AudioService.instance.init();
  runApp(const BrevetQuestApp());
}

class BrevetQuestApp extends StatefulWidget {
  const BrevetQuestApp({super.key});

  @override
  State<BrevetQuestApp> createState() => _BrevetQuestAppState();
}

class _BrevetQuestAppState extends State<BrevetQuestApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        AudioService.instance.pauseMusic();
        break;
      case AppLifecycleState.resumed:
        AudioService.instance.resumeMusic();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ThemeScope est placé via `builder` pour qu'il englobe les écrans
    // poussés par Navigator (sinon les routes en pile gardent leur
    // ancien thème). Tout écran qui appelle ThemeScope.of(context)
    // dans son build sera rebuild au changement de thème.
    return AnimatedBuilder(
      animation: ThemeService.instance,
      builder: (BuildContext _, _) => MaterialApp(
        title: 'Brevet Quest',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        builder: (BuildContext _, Widget? child) =>
            ThemeScope(child: child ?? const SizedBox.shrink()),
        home: const HomeScreen(),
      ),
    );
  }
}
