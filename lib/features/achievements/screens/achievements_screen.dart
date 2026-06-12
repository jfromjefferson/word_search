import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/shared/models/achievement.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final achievements = Achievement.allAchievements;
    final unlocked = profile.unlockedAchievementIds;

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🏆',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Text(
                  '${unlocked.length} / ${achievements.length}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Unlocked',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                final isUnlocked = unlocked.contains(achievement.type.name);
                return _AchievementCard(
                  achievement: achievement,
                  isUnlocked: isUnlocked,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        opacity: isUnlocked ? 0.15 : 0.05,
        border: isUnlocked
            ? Border.all(
                color: AppTheme.goldColor.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isUnlocked
                    ? AppTheme.goldColor.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: isUnlocked
                      ? AppTheme.goldColor.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Center(
                child: Text(
                  isUnlocked ? achievement.iconEmoji : '🔒',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      color: isUnlocked
                          ? AppTheme.goldColor
                          : AppTheme.textMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      color: isUnlocked
                          ? AppTheme.textSecondary
                          : AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isUnlocked)
              Column(
                children: [
                  Text(
                    '+${achievement.xpReward}',
                    style: const TextStyle(
                      color: AppTheme.xpColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '+${achievement.coinReward}',
                    style: const TextStyle(
                      color: AppTheme.goldColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (!isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withValues(alpha: 0.05),
                ),
                child: Text(
                  '${achievement.target}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
