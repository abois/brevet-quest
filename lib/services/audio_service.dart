import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Identifiants des effets sonores. Chaque entrée pointe sur un asset
/// optionnel — si le fichier n'existe pas, le `play()` est silencieusement
/// ignoré (pas de crash) pour permettre un déploiement sans assets.
enum Sfx { tap, correct, wrong, levelUp, badge, swipe }

extension SfxX on Sfx {
  String get assetPath => switch (this) {
        Sfx.tap => 'audio/sfx/tap.wav',
        Sfx.correct => 'audio/sfx/correct.wav',
        Sfx.wrong => 'audio/sfx/wrong.wav',
        Sfx.levelUp => 'audio/sfx/levelup.wav',
        Sfx.badge => 'audio/sfx/badge.wav',
        Sfx.swipe => 'audio/sfx/swipe.wav',
      };
}

/// Service audio singleton — musique d'ambiance en boucle + SFX courts.
///
/// Mute persisté via shared_preferences. Les fichiers manquants sont
/// gérés gracieusement (un warning, pas de crash).
class AudioService extends ChangeNotifier {
  AudioService._();

  static final AudioService instance = AudioService._();

  static const String _kMusicMuted = 'audio_music_muted';
  static const String _kSfxMuted = 'audio_sfx_muted';
  static const String _musicAsset = 'audio/music/ambient_loop.mp3';
  static const double _musicVolume = 0.18;
  static const double _sfxVolume = 0.85;

  /// Contexte audio pour la musique : on prend le focus normalement et on
  /// reste en lecture longue (`music`).
  static final AudioContext _musicCtx = AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: const <AVAudioSessionOptions>{
        AVAudioSessionOptions.mixWithOthers,
      },
    ),
    android: const AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gain,
    ),
  );

  /// Contexte audio pour les SFX : `audioFocus: none` pour ne PAS couper la
  /// musique d'ambiance, et content type sonification (sons courts).
  /// iOS : `ambient` mixe avec les autres apps par défaut, pas besoin
  /// (et incompatible avec) `mixWithOthers`.
  static final AudioContext _sfxCtx = AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: const <AVAudioSessionOptions>{},
    ),
    android: const AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  final AudioPlayer _music = AudioPlayer(playerId: 'music');
  final List<AudioPlayer> _sfxPool = <AudioPlayer>[
    AudioPlayer(playerId: 'sfx-0'),
    AudioPlayer(playerId: 'sfx-1'),
    AudioPlayer(playerId: 'sfx-2'),
    AudioPlayer(playerId: 'sfx-3'),
  ];
  int _sfxCursor = 0;

  bool _musicMuted = false;
  bool _sfxMuted = false;
  bool _musicTried = false;
  bool _musicAvailable = true;
  final Set<String> _missingSfx = <String>{};

  bool get musicMuted => _musicMuted;
  bool get sfxMuted => _sfxMuted;

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _musicMuted = prefs.getBool(_kMusicMuted) ?? false;
    _sfxMuted = prefs.getBool(_kSfxMuted) ?? false;
    await _music.setAudioContext(_musicCtx);
    await _music.setReleaseMode(ReleaseMode.loop);
    await _music.setVolume(_musicVolume);
    for (final AudioPlayer p in _sfxPool) {
      await p.setAudioContext(_sfxCtx);
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(_sfxVolume);
    }
    if (!_musicMuted) {
      // ignore: unawaited_futures
      _startMusic();
    }
    notifyListeners();
  }

  Future<void> _startMusic() async {
    if (_musicMuted || !_musicAvailable) return;
    try {
      await _music.stop();
      await _music.play(AssetSource(_musicAsset), volume: _musicVolume);
      _musicTried = true;
    } catch (e) {
      _musicAvailable = false;
      if (kDebugMode) {
        debugPrint('AudioService: music asset unavailable ($_musicAsset): $e');
      }
    }
  }

  Future<void> play(Sfx sfx) async {
    if (_sfxMuted) return;
    final String path = sfx.assetPath;
    if (_missingSfx.contains(path)) return;
    final AudioPlayer player = _sfxPool[_sfxCursor];
    _sfxCursor = (_sfxCursor + 1) % _sfxPool.length;
    try {
      await player.stop();
      await player.play(AssetSource(path), volume: _sfxVolume);
    } catch (e) {
      _missingSfx.add(path);
      if (kDebugMode) {
        debugPrint('AudioService: sfx asset unavailable ($path): $e');
      }
    }
  }

  Future<void> toggleMusic() async {
    _musicMuted = !_musicMuted;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kMusicMuted, _musicMuted);
    if (_musicMuted) {
      await _music.pause();
    } else {
      if (_musicTried) {
        await _music.resume();
      } else {
        await _startMusic();
      }
    }
    notifyListeners();
  }

  Future<void> toggleSfx() async {
    _sfxMuted = !_sfxMuted;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSfxMuted, _sfxMuted);
    notifyListeners();
  }

  Future<void> pauseMusic() async {
    if (!_musicMuted && _musicTried) await _music.pause();
  }

  Future<void> resumeMusic() async {
    if (!_musicMuted) {
      if (_musicTried) {
        await _music.resume();
      } else {
        await _startMusic();
      }
    }
  }

  @override
  void dispose() {
    _music.dispose();
    for (final AudioPlayer p in _sfxPool) {
      p.dispose();
    }
    super.dispose();
  }
}
