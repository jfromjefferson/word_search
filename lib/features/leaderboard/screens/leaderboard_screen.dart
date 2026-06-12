import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/extensions/app_extensions.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.surfaceDark,
        appBar: AppBar(
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textMuted,
            indicatorColor: AppTheme.primaryColor,
            tabs: [
              Tab(text: 'Global'),
              Tab(text: 'Weekly'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGlobalLeaderboard(),
            _buildWeeklyLeaderboard(),
            _buildFriendsLeaderboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalLeaderboard() {
    return _LeaderboardList(players: _mockGlobalPlayers, isGlobal: true);
  }

  Widget _buildWeeklyLeaderboard() {
    return _LeaderboardList(players: _mockWeeklyPlayers, isGlobal: false);
  }

  Widget _buildFriendsLeaderboard() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppTheme.textMuted),
          SizedBox(height: 16),
          Text(
            'Connect with friends\nto see their rankings!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  static List<Map<String, dynamic>> get _mockGlobalPlayers => [
        {'rank': 1, 'name': 'WordMaster99', 'level': 48, 'score': 125000, 'avatar': '👑'},
        {'rank': 2, 'name': 'PuzzleKing', 'level': 45, 'score': 118000, 'avatar': '🏆'},
        {'rank': 3, 'name': 'LexiconLord', 'level': 42, 'score': 112000, 'avatar': '🌟'},
        {'rank': 4, 'name': 'VocabVirtuoso', 'level': 40, 'score': 105000, 'avatar': '💎'},
        {'rank': 5, 'name': 'SearchSage', 'level': 38, 'score': 98000, 'avatar': '🧠'},
        {'rank': 6, 'name': 'LetterLegend', 'level': 35, 'score': 92000, 'avatar': '⚡'},
        {'rank': 7, 'name': 'GridGuru', 'level': 33, 'score': 87000, 'avatar': '🎯'},
        {'rank': 8, 'name': 'HuntHero', 'level': 30, 'score': 81000, 'avatar': '🦸'},
        {'rank': 9, 'name': 'WordWizard', 'level': 28, 'score': 76000, 'avatar': '🧙'},
        {'rank': 10, 'name': 'PuzzlePro', 'level': 25, 'score': 70000, 'avatar': '🎮'},
      ];

  static List<Map<String, dynamic>> get _mockWeeklyPlayers => [
        {'rank': 1, 'name': 'SpeedSolver', 'level': 35, 'score': 15200, 'avatar': '🚀'},
        {'rank': 2, 'name': 'QuickFinder', 'level': 32, 'score': 14800, 'avatar': '💨'},
        {'rank': 3, 'name': 'WordMaster99', 'level': 48, 'score': 14100, 'avatar': '👑'},
        {'rank': 4, 'name': 'DailyGrinder', 'level': 28, 'score': 13500, 'avatar': '📅'},
        {'rank': 5, 'name': 'WeekendWarr', 'level': 22, 'score': 12900, 'avatar': '⚔️'},
      ];
}

class _LeaderboardList extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  final bool isGlobal;

  const _LeaderboardList({
    required this.players,
    required this.isGlobal,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final rank = player['rank'] as int;
        final isTop3 = rank <= 3;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassCard(
            padding: const EdgeInsets.all(14),
            opacity: isTop3 ? 0.18 : 0.08,
            border: isTop3
                ? Border.all(
                    color: _rankColor(rank).withValues(alpha: 0.3),
                  )
                : null,
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    '#$rank',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _rankColor(rank),
                      fontWeight: FontWeight.bold,
                      fontSize: isTop3 ? 18 : 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  player['avatar'] as String,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player['name'] as String,
                        style: TextStyle(
                          color: isTop3 ? AppTheme.goldColor : AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Level ${player['level']}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isGlobal)
                  Text(
                    '${(player['score'] as int).formatted} XP',
                    style: TextStyle(
                      color: isTop3 ? AppTheme.goldColor : AppTheme.xpColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                if (!isGlobal)
                  Text(
                    '${(player['score'] as int).formatted} pts',
                    style: TextStyle(
                      color: isTop3 ? AppTheme.goldColor : AppTheme.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return AppTheme.goldColor;
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppTheme.textSecondary;
    }
  }
}
