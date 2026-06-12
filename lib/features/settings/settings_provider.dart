import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/services/storage_service.dart';
import 'package:word_search/shared/models/app_settings.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final StorageService _storage;

  SettingsNotifier(this._storage) : super(AppSettings());

  Future<void> init() async {
    state = await _storage.loadSettings();
  }

  Future<void> save() async {
    await _storage.saveSettings(state);
  }

  void toggleMusic() {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
    save();
  }

  void toggleSfx() {
    state = state.copyWith(sfxEnabled: !state.sfxEnabled);
    save();
  }

  void toggleHaptic() {
    state = state.copyWith(hapticFeedback: !state.hapticFeedback);
    save();
  }

  void toggleTimer() {
    state = state.copyWith(showTimer: !state.showTimer);
    save();
  }

  void toggleHighlightFound() {
    state = state.copyWith(highlightFoundWords: !state.highlightFoundWords);
    save();
  }

  void toggleAutoSave() {
    state = state.copyWith(autoSave: !state.autoSave);
    save();
  }

  void setMusicVolume(double volume) {
    state = state.copyWith(musicVolume: volume);
    save();
  }

  void setSfxVolume(double volume) {
    state = state.copyWith(sfxVolume: volume);
    save();
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
    save();
  }

  void completeOnboarding() {
    state = state.copyWith(onboardingCompleted: true);
    save();
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
    save();
  }

  void toggleReducedMotion() {
    state = state.copyWith(reducedMotion: !state.reducedMotion);
    save();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final notifier = SettingsNotifier(storage);
  notifier.init();
  return notifier;
});
