import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:word_search/shared/models/app_settings.dart';
import 'package:word_search/shared/models/user_profile.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Box? _box;

  Future<void> init() async {
    if (_box != null) return;
    _box = await Hive.openBox('word_quest');
    debugPrint('StorageService initialized with Hive CE');
  }

  Future<void> saveProfile(UserProfile profile) async {
    profile.updatedAt = DateTime.now();
    await _box?.put('profile', profile.toJson());
  }

  Future<UserProfile> loadProfile() async {
    final data = _box?.get('profile');
    if (data != null && data is Map) {
      return UserProfile.fromJson(Map<String, dynamic>.from(data));
    }
    final defaultProfile = UserProfile();
    await saveProfile(defaultProfile);
    return defaultProfile;
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _box?.put('settings', settings.toJson());
  }

  Future<AppSettings> loadSettings() async {
    final data = _box?.get('settings');
    if (data != null && data is Map) {
      return AppSettings.fromJson(Map<String, dynamic>.from(data));
    }
    final defaultSettings = AppSettings();
    await saveSettings(defaultSettings);
    return defaultSettings;
  }

  Future<void> savePuzzle(Map<String, dynamic> data) async {
    await _box?.put('activePuzzle', data);
  }

  Future<Map<String, dynamic>?> loadPuzzle() async {
    final data = _box?.get('activePuzzle');
    if (data != null && data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  bool get hasSavedPuzzle => _box?.containsKey('activePuzzle') ?? false;

  Future<void> clearPuzzle() async {
    await _box?.delete('activePuzzle');
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }
}
