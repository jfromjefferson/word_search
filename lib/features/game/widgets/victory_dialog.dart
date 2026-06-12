import 'package:flutter/material.dart';
import 'package:word_search/core/constants/app_strings.dart';
import 'package:word_search/core/extensions/app_extensions.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/shared/models/achievement.dart';
import 'package:word_search/shared/models/puzzle.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class VictoryDialog extends StatelessWidget {
  final Puzzle puzzle;
  final int xpEarned;
  final int coinsEarned;
  final List<String> achievements;
  final bool showLevelUp;
  final int levelsGained;
  final int newLevel;
  final VoidCallback onDismiss;
  final VoidCallback onPlayAgain;

  const VictoryDialog({
    super.key,
    required this.puzzle,
    required this.xpEarned,
    required this.coinsEarned,
    required this.achievements,
    required this.showLevelUp,
    required this.levelsGained,
    required this.newLevel,
    required this.onDismiss,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.puzzleComplete(locale),
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${puzzle.difficulty.labelFor(locale)} - ${puzzle.category.displayNameFor(locale)}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatsRow(context),
              const SizedBox(height: 20),
              _buildRewards(context),
              if (achievements.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildAchievements(context),
              ],
              if (showLevelUp) ...[
                const SizedBox(height: 16),
                _buildLevelUp(context),
              ],
              const SizedBox(height: 24),
            GradientButton(
              text: AppStrings.playAgain(locale),
              icon: Icons.replay,
              onPressed: onPlayAgain,
            ),
            const SizedBox(height: 10),
            GradientButton(
              text: AppStrings.backToHome(locale),
              icon: Icons.home,
                gradient: const LinearGradient(
                  colors: [AppTheme.surfaceLight, AppTheme.surfaceMedium],
                ),
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final completionTime = puzzle.completionTime;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatBox(
          icon: Icons.text_fields,
          label: 'Words',
          value: '${puzzle.wordsFoundCount}/${puzzle.totalWords}',
          color: AppTheme.secondaryColor,
        ),
        _StatBox(
          icon: Icons.timer,
          label: 'Time',
          value: completionTime?.formatted ?? '--:--',
          color: AppTheme.accentColor,
        ),
        _StatBox(
          icon: Icons.lightbulb_outline,
          label: 'Hints',
          value: '${puzzle.hintsUsed}',
          color: AppTheme.warningColor,
        ),
        _StatBox(
          icon: puzzle.perfect ? Icons.star : Icons.star_border,
          label: 'Perfect',
          value: puzzle.perfect ? 'Yes!' : 'No',
          color: AppTheme.goldColor,
        ),
      ],
    );
  }

  Widget _buildRewards(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Rewards Earned',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RewardItem(
                emoji: '⭐',
                value: '+$xpEarned XP',
                color: AppTheme.xpColor,
              ),
              _RewardItem(
                emoji: '🪙',
                value: '+$coinsEarned',
                color: AppTheme.goldColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    final unlockedAchievements = achievements
        .map((id) => Achievement.allAchievements
            .firstWhere((a) => a.type.name == id))
        .toList();

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Achievements Unlocked!',
            style: TextStyle(
              color: AppTheme.goldColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...unlockedAchievements.map((achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(achievement.iconEmoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            achievement.description,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text('+${achievement.xpReward} XP',
                            style: const TextStyle(
                                color: AppTheme.xpColor, fontSize: 11)),
                        Text('+${achievement.coinReward} 🪙',
                            style: const TextStyle(
                                color: AppTheme.goldColor, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLevelUp(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppTheme.goldGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('⬆️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            'Level ${newLevel - levelsGained + 1} → $newLevel',
            style: const TextStyle(
              color: AppTheme.surfaceDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (levelsGained > 1)
            Text(
              '($levelsGained levels gained!)',
              style: TextStyle(
                color: AppTheme.surfaceDark.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String emoji;
  final String value;
  final Color color;

  const _RewardItem({
    required this.emoji,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
