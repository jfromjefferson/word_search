import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:word_search/shared/models/app_settings.dart';
import 'package:word_search/shared/models/user_profile.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Map<String, dynamic> _memoryCache = {};

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    debugPrint('StorageService initialized (in-memory mode)');
  }

  Future<void> saveProfile(UserProfile profile) async {
    profile.updatedAt = DateTime.now();
    _memoryCache['profile'] = jsonEncode(profile.toJson());
  }

  Future<UserProfile> loadProfile() async {
    final data = _memoryCache['profile'] as String?;
    if (data != null) {
      return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
    }
    final defaultProfile = UserProfile();
    await saveProfile(defaultProfile);
    return defaultProfile;
  }

  Future<void> saveSettings(AppSettings settings) async {
    _memoryCache['settings'] = jsonEncode(settings.toJson());
  }

  Future<AppSettings> loadSettings() async {
    final data = _memoryCache['settings'] as String?;
    if (data != null) {
      return AppSettings.fromJson(jsonDecode(data) as Map<String, dynamic>);
    }
    final defaultSettings = AppSettings();
    await saveSettings(defaultSettings);
    return defaultSettings;
  }

  Future<void> savePuzzleState(Map<String, dynamic> puzzleData) async {
    _memoryCache['activePuzzle'] = jsonEncode(puzzleData);
  }

  Future<Map<String, dynamic>?> loadPuzzleState() async {
    final data = _memoryCache['activePuzzle'] as String?;
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearPuzzleState() async {
    _memoryCache.remove('activePuzzle');
  }

  Future<void> saveLastDailyDate(DateTime date) async {
    _memoryCache['lastDailyDate'] = date.toIso8601String();
  }

  Future<DateTime?> loadLastDailyDate() async {
    final data = _memoryCache['lastDailyDate'] as String?;
    if (data != null) return DateTime.tryParse(data);
    return null;
  }

  Future<void> saveDailyClaimDate(DateTime date) async {
    _memoryCache['dailyClaimDate'] = date.toIso8601String();
  }

  Future<DateTime?> loadDailyClaimDate() async {
    final data = _memoryCache['dailyClaimDate'] as String?;
    if (data != null) return DateTime.tryParse(data);
    return null;
  }

  Future<void> saveGamesPlayedToday(int count) async {
    _memoryCache['gamesPlayedToday'] = count.toString();
  }

  Future<int> loadGamesPlayedToday() async {
    final data = _memoryCache['gamesPlayedToday'] as String?;
    return int.tryParse(data ?? '0') ?? 0;
  }

  Future<void> clearCache() async {
    _memoryCache.clear();
  }
}
