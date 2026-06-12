class UserProfile {
  String username;
  String avatarId;
  int xp;
  int coins;
  int totalWordsFound;
  int totalPuzzlesCompleted;
  int dailyLoginStreak;
  DateTime lastLoginDate;
  int bestCompletionTimeMs;
  int perfectPuzzles;
  int totalHintsUsed;
  int fastCompletions;
  Map<String, int> bestTimePerDifficulty;
  List<String> unlockedAchievementIds;
  List<String> ownedShopItemIds;
  String activeThemeId;
  String activeBackgroundId;
  String activeEffectId;
  int gamesPlayed;
  int totalTimePlayedMs;
  int consecutiveVictories;
  Map<String, int> puzzlesPerDifficulty;
  Map<String, int> wordsPerCategory;
  int coinsEarned;
  int coinsSpent;
  List<int> recentCompletionTimes;
  DateTime createdAt;
  DateTime updatedAt;

  UserProfile({
    this.username = 'Word Hunter',
    this.avatarId = 'default',
    this.xp = 0,
    this.coins = 100,
    this.totalWordsFound = 0,
    this.totalPuzzlesCompleted = 0,
    this.dailyLoginStreak = 0,
    DateTime? lastLoginDate,
    this.bestCompletionTimeMs = 0,
    this.perfectPuzzles = 0,
    this.totalHintsUsed = 0,
    this.fastCompletions = 0,
    Map<String, int>? bestTimePerDifficulty,
    List<String>? unlockedAchievementIds,
    List<String>? ownedShopItemIds,
    this.activeThemeId = 'default',
    this.activeBackgroundId = 'default',
    this.activeEffectId = 'default',
    this.gamesPlayed = 0,
    this.totalTimePlayedMs = 0,
    this.consecutiveVictories = 0,
    Map<String, int>? puzzlesPerDifficulty,
    Map<String, int>? wordsPerCategory,
    this.coinsEarned = 0,
    this.coinsSpent = 0,
    List<int>? recentCompletionTimes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : lastLoginDate = lastLoginDate ?? DateTime.now(),
        bestTimePerDifficulty =
            bestTimePerDifficulty ?? {},
        unlockedAchievementIds =
            unlockedAchievementIds ?? [],
        ownedShopItemIds =
            ownedShopItemIds ?? [],
        puzzlesPerDifficulty =
            puzzlesPerDifficulty ?? {},
        wordsPerCategory =
            wordsPerCategory ?? {},
        recentCompletionTimes =
            recentCompletionTimes ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  int get level {
    int totalXp = 0;
    for (int i = 0; i < xpLevels.length; i++) {
      totalXp += xpLevels[i];
      if (xp < totalXp) return i;
    }
    return xpLevels.length;
  }

  int get xpToNextLevel {
    final lvl = level;
    if (lvl >= xpLevels.length) return 0;
    int totalXp = 0;
    for (int i = 0; i < lvl; i++) {
      totalXp += xpLevels[i];
    }
    return totalXp + xpLevels[lvl] - xp;
  }

  int get xpForCurrentLevel {
    final lvl = level;
    if (lvl == 0) return 0;
    int totalXp = 0;
    for (int i = 0; i < lvl; i++) {
      totalXp += xpLevels[i];
    }
    return totalXp;
  }

  double get xpProgress {
    final next = xpToNextLevel;
    if (next == 0) return 1.0;
    final current = xpLevels[level];
    if (current == 0) return 1.0;
    return 1.0 - (next / current);
  }

  double get accuracy {
    if (gamesPlayed == 0) return 100.0;
    return ((totalWordsFound /
                (totalWordsFound + totalHintsUsed + (gamesPlayed * 0.5)))
            .clamp(0.0, 1.0)) *
        100.0;
  }

  int get averageCompletionTimeMs {
    if (recentCompletionTimes.isEmpty) return 0;
    return recentCompletionTimes.reduce((a, b) => a + b) ~/
        recentCompletionTimes.length;
  }

  static const List<int> xpLevels = [
    0, 100, 250, 500, 800, 1200, 1700, 2300, 3000, 3800,
    4700, 5700, 6800, 8000, 9300, 10700, 12200, 13800, 15500, 17300,
    19200, 21200, 23300, 25500, 27800, 30200, 32700, 35300, 38000, 40800,
    43700, 46700, 49800, 53000, 56300, 59700, 63200, 66800, 70500, 74300,
    78200, 82200, 86300, 90500, 94800, 99200, 103700, 108300, 113000, 117800,
  ];

  Map<String, dynamic> toJson() => {
        'username': username,
        'avatarId': avatarId,
        'xp': xp,
        'coins': coins,
        'totalWordsFound': totalWordsFound,
        'totalPuzzlesCompleted': totalPuzzlesCompleted,
        'dailyLoginStreak': dailyLoginStreak,
        'lastLoginDate': lastLoginDate.toIso8601String(),
        'bestCompletionTimeMs': bestCompletionTimeMs,
        'perfectPuzzles': perfectPuzzles,
        'totalHintsUsed': totalHintsUsed,
        'fastCompletions': fastCompletions,
        'bestTimePerDifficulty': bestTimePerDifficulty,
        'unlockedAchievementIds': unlockedAchievementIds,
        'ownedShopItemIds': ownedShopItemIds,
        'activeThemeId': activeThemeId,
        'activeBackgroundId': activeBackgroundId,
        'activeEffectId': activeEffectId,
        'gamesPlayed': gamesPlayed,
        'totalTimePlayedMs': totalTimePlayedMs,
        'consecutiveVictories': consecutiveVictories,
        'puzzlesPerDifficulty': puzzlesPerDifficulty,
        'wordsPerCategory': wordsPerCategory,
        'coinsEarned': coinsEarned,
        'coinsSpent': coinsSpent,
        'recentCompletionTimes': recentCompletionTimes,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        username: json['username'] as String? ?? 'Word Hunter',
        avatarId: json['avatarId'] as String? ?? 'default',
        xp: json['xp'] as int? ?? 0,
        coins: json['coins'] as int? ?? 100,
        totalWordsFound: json['totalWordsFound'] as int? ?? 0,
        totalPuzzlesCompleted: json['totalPuzzlesCompleted'] as int? ?? 0,
        dailyLoginStreak: json['dailyLoginStreak'] as int? ?? 0,
        lastLoginDate: DateTime.tryParse(json['lastLoginDate'] as String? ?? '') ?? DateTime.now(),
        bestCompletionTimeMs: json['bestCompletionTimeMs'] as int? ?? 0,
        perfectPuzzles: json['perfectPuzzles'] as int? ?? 0,
        totalHintsUsed: json['totalHintsUsed'] as int? ?? 0,
        fastCompletions: json['fastCompletions'] as int? ?? 0,
        bestTimePerDifficulty:
            Map<String, int>.from(json['bestTimePerDifficulty'] as Map? ?? {}),
        unlockedAchievementIds:
            List<String>.from(json['unlockedAchievementIds'] as List? ?? []),
        ownedShopItemIds:
            List<String>.from(json['ownedShopItemIds'] as List? ?? []),
        activeThemeId: json['activeThemeId'] as String? ?? 'default',
        activeBackgroundId: json['activeBackgroundId'] as String? ?? 'default',
        activeEffectId: json['activeEffectId'] as String? ?? 'default',
        gamesPlayed: json['gamesPlayed'] as int? ?? 0,
        totalTimePlayedMs: json['totalTimePlayedMs'] as int? ?? 0,
        consecutiveVictories: json['consecutiveVictories'] as int? ?? 0,
        puzzlesPerDifficulty:
            Map<String, int>.from(json['puzzlesPerDifficulty'] as Map? ?? {}),
        wordsPerCategory:
            Map<String, int>.from(json['wordsPerCategory'] as Map? ?? {}),
        coinsEarned: json['coinsEarned'] as int? ?? 0,
        coinsSpent: json['coinsSpent'] as int? ?? 0,
        recentCompletionTimes:
            List<int>.from(json['recentCompletionTimes'] as List? ?? []),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      );
}
