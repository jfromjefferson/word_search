import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/game/providers/game_provider.dart';
import 'package:word_search/features/game/screens/game_screen.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class DailyScreen extends ConsumerStatefulWidget {
  const DailyScreen({super.key});

  @override
  ConsumerState<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends ConsumerState<DailyScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final gameState = ref.watch(gameProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildDailyStreak(context, profile),
          const SizedBox(height: 20),
          _buildDailyChallenge(context, ref, gameState),
          const SizedBox(height: 20),
          _buildDailyRewards(context, ref, profile),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Daily Challenge',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '📅',
          style: TextStyle(fontSize: 28),
        ),
      ],
    );
  }

  Widget _buildDailyStreak(BuildContext context, profile) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFFFA502)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 48)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.dailyLoginStreak} Day Streak',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep it up! Play daily to earn rewards.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallenge(BuildContext context, WidgetRef ref, GameState gameState) {
    return GradientButton(
      text: gameState.isLoading ? 'Loading...' : 'Play Daily Challenge',
      icon: Icons.play_arrow_rounded,
      isLoading: gameState.isLoading,
      height: 64,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFFFA502)],
      ),
      onPressed: gameState.isLoading
          ? null
          : () async {
              ref.read(gameProvider.notifier)
                ..setMode(GameMode.daily)
                ..setDifficulty(Difficulty.medium);
              await ref.read(gameProvider.notifier).startGame();
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              }
            },
    );
  }

  Widget _buildDailyRewards(BuildContext context, WidgetRef ref, profile) {
    final dailyRewards = [
      (1, '🪙', '50 Coins', 50, false),
      (2, '⭐', '100 XP', 100, false),
      (3, '💡', '1 Hint', 1, false),
      (4, '🪙', '100 Coins', 100, false),
      (5, '⭐', '200 XP', 200, false),
      (6, '💡', '2 Hints', 2, false),
      (7, '🎁', 'Premium', 200, true),
    ];

    final streak = profile.dailyLoginStreak;
    final canClaimToday = _canClaimToday();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Rewards',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dailyRewards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final (day, emoji, label, amount, isPremium) = dailyRewards[index];
              final isClaimed = day < streak;
              final isToday = day == streak && canClaimToday;
              final isLocked = day > streak || (day == streak && !canClaimToday);

              return GestureDetector(
                onTap: isToday ? () => _claimReward(day, amount, emoji) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isToday
                        ? AppTheme.goldGradient
                        : isPremium
                            ? AppTheme.accentGradient
                            : null,
                    color: isLocked
                        ? Colors.white.withValues(alpha: 0.05)
                        : isClaimed
                            ? AppTheme.successColor.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.1),
                    border: isToday
                        ? Border.all(color: AppTheme.goldColor, width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isClaimed ? '✅' : emoji,
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Day $day',
                        style: TextStyle(
                          color: isToday ? Colors.white : AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _canClaimToday() {
    return true;
  }

  void _claimReward(int day, int amount, String emoji) {
    final notifier = ref.read(profileProvider.notifier);
    switch (day) {
      case 1:
      case 4:
        notifier.addCoins(amount);
        break;
      case 2:
      case 5:
        notifier.addXP(amount);
        break;
      case 3:
      case 6:
        notifier.addHints(amount);
        break;
      case 7:
        notifier.addCoins(200);
        notifier.addXP(100);
        break;
    }
    notifier.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Day $day reward claimed! $emoji'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
