import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/services/storage_service.dart';
import 'package:word_search/shared/models/user_profile.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class ProfileNotifier extends StateNotifier<UserProfile> {
  final StorageService _storage;

  ProfileNotifier(this._storage) : super(UserProfile());

  Future<void> init() async {
    state = await _storage.loadProfile();
  }

  Future<void> save() async {
    await _storage.saveProfile(state);
  }

  void addXP(int amount) {
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp + amount,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void addCoins(int amount) {
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins + amount,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned + (amount > 0 ? amount : 0),
      coinsSpent: state.coinsSpent + (amount < 0 ? -amount : 0),
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void spendCoins(int amount) {
    if (state.coins >= amount) {
      addCoins(-amount);
    }
  }

  void recordWordFound(String word, String category) {
    final newWordsPerCategory =
        Map<String, int>.from(state.wordsPerCategory);
    newWordsPerCategory[category] =
        (newWordsPerCategory[category] ?? 0) + 1;
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound + 1,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: newWordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void recordPuzzleCompleted({
    required String difficulty,
    required int completionTimeMs,
    required bool perfect,
    required int hintsUsed,
    int? fastCompletionMs,
  }) {
    final newPuzzlesPerDifficulty =
        Map<String, int>.from(state.puzzlesPerDifficulty);
    newPuzzlesPerDifficulty[difficulty] =
        (newPuzzlesPerDifficulty[difficulty] ?? 0) + 1;

    final newBestTimes =
        Map<String, int>.from(state.bestTimePerDifficulty);
    if (!newBestTimes.containsKey(difficulty) ||
        completionTimeMs < newBestTimes[difficulty]!) {
      newBestTimes[difficulty] = completionTimeMs;
    }

    final newTimes = List<int>.from(state.recentCompletionTimes);
    newTimes.add(completionTimeMs);
    if (newTimes.length > 20) newTimes.removeAt(0);

    final isFast = fastCompletionMs != null && completionTimeMs <= fastCompletionMs;

    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted + 1,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: completionTimeMs < state.bestCompletionTimeMs || state.bestCompletionTimeMs == 0
          ? completionTimeMs : state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles + (perfect ? 1 : 0),
      totalHintsUsed: state.totalHintsUsed + hintsUsed,
      fastCompletions: state.fastCompletions + (isFast ? 1 : 0),
      bestTimePerDifficulty: newBestTimes,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed + 1,
      totalTimePlayedMs: state.totalTimePlayedMs + completionTimeMs,
      consecutiveVictories: state.consecutiveVictories + 1,
      puzzlesPerDifficulty: newPuzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: newTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void recordDefeat() {
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed + 1,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: 0,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void addHints(int count) {
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void updateUsername(String name) {
    state = UserProfile(
      username: name,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void setAvatar(String avatarId) {
    state = UserProfile(
      username: state.username,
      avatarId: avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void unlockAchievement(String achievementId) {
    if (state.unlockedAchievementIds.contains(achievementId)) return;
    final newAchievements = List<String>.from(state.unlockedAchievementIds);
    newAchievements.add(achievementId);
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: newAchievements,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void ownShopItem(String itemId) {
    if (state.ownedShopItemIds.contains(itemId)) return;
    final newItems = List<String>.from(state.ownedShopItemIds);
    newItems.add(itemId);
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: newItems,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void setActiveTheme(String themeId) {
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: themeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void setActiveBackground(String bgId) {
    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: state.dailyLoginStreak,
      lastLoginDate: state.lastLoginDate,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: bgId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void handleDailyLogin() {
    final now = DateTime.now();
    final lastLogin = state.lastLoginDate;
    final yesterday = now.subtract(const Duration(days: 1));

    int newStreak = state.dailyLoginStreak;

    if (lastLogin.year == now.year &&
        lastLogin.month == now.month &&
        lastLogin.day == now.day) {
      return;
    }

    if (lastLogin.year == yesterday.year &&
        lastLogin.month == yesterday.month &&
        lastLogin.day == yesterday.day) {
      newStreak++;
    } else {
      newStreak = 1;
    }

    state = UserProfile(
      username: state.username,
      avatarId: state.avatarId,
      xp: state.xp,
      coins: state.coins,
      totalWordsFound: state.totalWordsFound,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted,
      dailyLoginStreak: newStreak,
      lastLoginDate: now,
      bestCompletionTimeMs: state.bestCompletionTimeMs,
      perfectPuzzles: state.perfectPuzzles,
      totalHintsUsed: state.totalHintsUsed,
      fastCompletions: state.fastCompletions,
      bestTimePerDifficulty: state.bestTimePerDifficulty,
      unlockedAchievementIds: state.unlockedAchievementIds,
      ownedShopItemIds: state.ownedShopItemIds,
      activeThemeId: state.activeThemeId,
      activeBackgroundId: state.activeBackgroundId,
      activeEffectId: state.activeEffectId,
      gamesPlayed: state.gamesPlayed,
      totalTimePlayedMs: state.totalTimePlayedMs,
      consecutiveVictories: state.consecutiveVictories,
      puzzlesPerDifficulty: state.puzzlesPerDifficulty,
      wordsPerCategory: state.wordsPerCategory,
      coinsEarned: state.coinsEarned,
      coinsSpent: state.coinsSpent,
      recentCompletionTimes: state.recentCompletionTimes,
      createdAt: state.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final notifier = ProfileNotifier(storage);
  notifier.init();
  return notifier;
});
