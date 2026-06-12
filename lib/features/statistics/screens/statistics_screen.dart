import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/extensions/app_extensions.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildOverviewCards(context, profile),
            const SizedBox(height: 20),
            _buildPerformanceMetrics(context, profile),
            const SizedBox(height: 20),
            _buildDifficultyBreakdown(context, profile),
            const SizedBox(height: 20),
            _buildAccuracyChart(context, profile),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, profile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.videogame_asset,
                label: 'Games Played',
                value: '${profile.gamesPlayed}',
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.extension,
                label: 'Puzzles',
                value: '${profile.totalPuzzlesCompleted}',
                color: AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.text_fields,
                label: 'Words Found',
                value: profile.totalWordsFound.formatted,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department,
                label: 'Best Streak',
                value: '${profile.dailyLoginStreak}d',
                color: AppTheme.warningColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context, profile) {
    final avgTimeMs = profile.averageCompletionTimeMs;
    final avgTimeStr = avgTimeMs > 0
        ? Duration(milliseconds: avgTimeMs).formatted
        : '--:--';

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricItem(
                label: 'Avg Time',
                value: avgTimeStr,
                icon: Icons.timer,
                color: AppTheme.secondaryColor,
              ),
              _MetricItem(
                label: 'Accuracy',
                value: '${profile.accuracy.toStringAsFixed(1)}%',
                icon: Icons.check_circle,
                color: AppTheme.successColor,
              ),
              _MetricItem(
                label: 'Perfect',
                value: '${profile.perfectPuzzles}',
                icon: Icons.star,
                color: AppTheme.goldColor,
              ),
              _MetricItem(
                label: 'Fast Wins',
                value: '${profile.fastCompletions}',
                icon: Icons.bolt,
                color: AppTheme.accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBreakdown(BuildContext context, profile) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'By Difficulty',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...Difficulty.values.map((diff) {
            final count = profile.puzzlesPerDifficulty[diff.name] ?? 0;
            final bestTime = profile.bestTimePerDifficulty[diff.name];
            final bestTimeStr = bestTime != null
                ? Duration(milliseconds: bestTime).formattedShort
                : 'N/A';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      diff.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '$count puzzles',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Best: $bestTimeStr',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccuracyChart(BuildContext context, profile) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Summary',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Total XP',
            value: profile.xp.formatted,
            color: AppTheme.xpColor,
          ),
          _SummaryRow(
            label: 'Level',
            value: '${profile.level}',
            color: AppTheme.primaryColor,
          ),
          _SummaryRow(
            label: 'Total Coins Earned',
            value: profile.coinsEarned.formatted,
            color: AppTheme.goldColor,
          ),
          _SummaryRow(
            label: 'Total Coins Spent',
            value: profile.coinsSpent.formatted,
            color: AppTheme.accentColor,
          ),
          _SummaryRow(
            label: 'Hints Used',
            value: '${profile.totalHintsUsed}',
            color: AppTheme.warningColor,
          ),
          _SummaryRow(
            label: 'Best Time (Any)',
            value: profile.bestCompletionTimeMs > 0
                ? Duration(milliseconds: profile.bestCompletionTimeMs).formatted
                : 'N/A',
            color: AppTheme.secondaryColor,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
