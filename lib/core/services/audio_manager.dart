import 'package:flutter/services.dart';
import 'package:word_search/core/services/storage_service.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final StorageService _storage = StorageService();

  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;

  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  Future<void> init() async {
    final settings = await _storage.loadSettings();
    _musicEnabled = settings.musicEnabled;
    _sfxEnabled = settings.sfxEnabled;
    _musicVolume = settings.musicVolume;
    _sfxVolume = settings.sfxVolume;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    final settings = await _storage.loadSettings();
    settings.musicEnabled = enabled;
    await _storage.saveSettings(settings);
    if (enabled) {
      await playMusic();
    } else {
      await stopMusic();
    }
  }

  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
    final settings = await _storage.loadSettings();
    settings.sfxEnabled = enabled;
    await _storage.saveSettings(settings);
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume;
    final settings = await _storage.loadSettings();
    settings.musicVolume = volume;
    await _storage.saveSettings(settings);
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume;
    final settings = await _storage.loadSettings();
    settings.sfxVolume = volume;
    await _storage.saveSettings(settings);
  }

  Future<void> playMusic() async {
    if (!_musicEnabled) return;
    HapticFeedback.lightImpact();
    // In production: use audioplayers package with actual audio files
  }

  Future<void> stopMusic() async {
    // In production: stop background music
  }

  Future<void> playButtonTap() async {
    if (!_sfxEnabled) return;
    HapticFeedback.selectionClick();
  }

  Future<void> playWordFound() async {
    if (!_sfxEnabled) return;
    HapticFeedback.mediumImpact();
  }

  Future<void> playVictory() async {
    if (!_sfxEnabled) return;
    HapticFeedback.heavyImpact();
  }

  Future<void> playLevelUp() async {
    if (!_sfxEnabled) return;
    HapticFeedback.heavyImpact();
  }

  Future<void> playAchievement() async {
    if (!_sfxEnabled) return;
    HapticFeedback.heavyImpact();
  }

  Future<void> playCoin() async {
    if (!_sfxEnabled) return;
    HapticFeedback.lightImpact();
  }

  Future<void> playError() async {
    if (!_sfxEnabled) return;
    HapticFeedback.lightImpact();
  }

  Future<void> playHint() async {
    if (!_sfxEnabled) return;
    HapticFeedback.mediumImpact();
  }

  Future<void> playSelect() async {
    if (!_sfxEnabled) return;
    HapticFeedback.selectionClick();
  }
}
