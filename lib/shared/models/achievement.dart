import 'package:word_search/core/constants/enums.dart';

class Achievement {
  final AchievementType type;
  final String title;
  final String description;
  final String iconEmoji;
  final int target;
  final int xpReward;
  final int coinReward;

  const Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.iconEmoji,
    this.target = 1,
    this.xpReward = 0,
    this.coinReward = 0,
  });

  static List<Achievement> get allAchievements => [
        const Achievement(
          type: AchievementType.firstVictory,
          title: 'First Victory',
          description: 'Complete your first puzzle',
          iconEmoji: '🏆',
          xpReward: 50,
          coinReward: 25,
        ),
        const Achievement(
          type: AchievementType.tenPuzzles,
          title: 'Puzzle Apprentice',
          description: 'Complete 10 puzzles',
          iconEmoji: '🧩',
          target: 10,
          xpReward: 150,
          coinReward: 50,
        ),
        const Achievement(
          type: AchievementType.hundredWords,
          title: 'Word Collector',
          description: 'Find 100 words',
          iconEmoji: '📚',
          target: 100,
          xpReward: 200,
          coinReward: 75,
        ),
        const Achievement(
          type: AchievementType.sevenDayStreak,
          title: 'Dedicated Player',
          description: 'Login for 7 days in a row',
          iconEmoji: '🔥',
          target: 7,
          xpReward: 300,
          coinReward: 100,
        ),
        const Achievement(
          type: AchievementType.perfectPuzzle,
          title: 'Perfect Solver',
          description: 'Complete a puzzle with no hints or mistakes',
          iconEmoji: '💎',
          xpReward: 250,
          coinReward: 100,
        ),
        const Achievement(
          type: AchievementType.speedMaster,
          title: 'Speed Master',
          description: 'Complete a puzzle in under 60 seconds',
          iconEmoji: '⚡',
          xpReward: 200,
          coinReward: 75,
        ),
        const Achievement(
          type: AchievementType.puzzleLegend,
          title: 'Puzzle Legend',
          description: 'Complete 50 puzzles',
          iconEmoji: '👑',
          target: 50,
          xpReward: 500,
          coinReward: 200,
        ),
        const Achievement(
          type: AchievementType.noHintsUsed,
          title: 'No Help Needed',
          description: 'Complete 5 puzzles without hints',
          iconEmoji: '🧠',
          target: 5,
          xpReward: 200,
          coinReward: 75,
        ),
        const Achievement(
          type: AchievementType.allCategories,
          title: 'Category Master',
          description: 'Play all word categories',
          iconEmoji: '🌈',
          target: 10,
          xpReward: 300,
          coinReward: 100,
        ),
        const Achievement(
          type: AchievementType.coinCollector,
          title: 'Coin Collector',
          description: 'Earn 1000 coins total',
          iconEmoji: '💰',
          target: 1000,
          xpReward: 150,
          coinReward: 50,
        ),
        const Achievement(
          type: AchievementType.levelTen,
          title: 'Seasoned Player',
          description: 'Reach level 10',
          iconEmoji: '⭐',
          target: 10,
          xpReward: 200,
          coinReward: 75,
        ),
        const Achievement(
          type: AchievementType.levelTwentyFive,
          title: 'Elite Player',
          description: 'Reach level 25',
          iconEmoji: '🌟',
          target: 25,
          xpReward: 400,
          coinReward: 150,
        ),
        const Achievement(
          type: AchievementType.levelFifty,
          title: 'Grand Master',
          description: 'Reach level 50',
          iconEmoji: '💫',
          target: 50,
          xpReward: 1000,
          coinReward: 500,
        ),
        const Achievement(
          type: AchievementType.quickSolver,
          title: 'Quick Solver',
          description: 'Complete 10 puzzles in under 90 seconds each',
          iconEmoji: '🚀',
          target: 10,
          xpReward: 300,
          coinReward: 100,
        ),
        const Achievement(
          type: AchievementType.marathoner,
          title: 'Marathon Player',
          description: 'Play 10 games in a single day',
          iconEmoji: '🏃',
          target: 10,
          xpReward: 250,
          coinReward: 100,
        ),
        const Achievement(
          type: AchievementType.wordHunter,
          title: 'Word Hunter',
          description: 'Find 500 words total',
          iconEmoji: '🎯',
          target: 500,
          xpReward: 500,
          coinReward: 200,
        ),
      ];

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'title': title,
        'description': description,
        'iconEmoji': iconEmoji,
        'target': target,
        'xpReward': xpReward,
        'coinReward': coinReward,
      };
}

class UnlockedAchievement {
  final AchievementType type;
  final DateTime unlockedAt;

  const UnlockedAchievement({
    required this.type,
    required this.unlockedAt,
  });

  Achievement get definition =>
      Achievement.allAchievements.firstWhere((a) => a.type == type);

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'unlockedAt': unlockedAt.toIso8601String(),
      };

  factory UnlockedAchievement.fromJson(Map<String, dynamic> json) =>
      UnlockedAchievement(
        type: AchievementType.values.byName(json['type'] as String),
        unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      );
}
