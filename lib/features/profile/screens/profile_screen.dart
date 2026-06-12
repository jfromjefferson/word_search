import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/app_strings.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/achievements/screens/achievements_screen.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/features/settings/screens/settings_screen.dart';
import 'package:word_search/features/statistics/screens/statistics_screen.dart';
import 'package:word_search/shared/widgets/game_widgets.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileHeader(context, profile, locale),
          const SizedBox(height: 20),
          _buildXpSection(context, profile, locale),
          const SizedBox(height: 16),
          _buildQuickStats(context, profile, locale),
          const SizedBox(height: 16),
          _buildMenuItems(context, profile, locale),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, profile, String locale) {
    return Column(
      children: [
        Stack(
          children: [
            LevelBadge(level: profile.level, size: 72, showGlow: true),
            Positioned(
              bottom: -2,
              right: -4,
              child: GestureDetector(
                onTap: () => _showEditProfile(context, locale),
                child: GlassContainer(
                  padding: const EdgeInsets.all(6),
                  borderRadius: 12,
                  child: const Icon(Icons.edit, size: 14, color: AppTheme.textSecondary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          profile.username,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${AppStrings.levelWord(locale)} ${profile.level} ${AppStrings.wordHunter(locale)}',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildXpSection(BuildContext context, profile, String locale) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  AppStrings.xpProgress(locale),
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  AppStrings.toNextLevel(locale, profile.xpToNextLevel),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          XpBar(
            currentXp: profile.xp,
            level: profile.level,
            progress: profile.xpProgress,
            xpToNext: profile.xpToNextLevel,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ProfileStat(icon: Icons.emoji_events, label: AppStrings.puzzlesCompleted(locale), value: '${profile.totalPuzzlesCompleted}')),
              Expanded(child: _ProfileStat(icon: Icons.text_fields, label: AppStrings.wordsFound(locale), value: '${profile.totalWordsFound}')),
              Expanded(child: _ProfileStat(icon: Icons.local_fire_department, label: AppStrings.bestStreak(locale), value: '${profile.dailyLoginStreak}d')),
              Expanded(child: _ProfileStat(icon: Icons.star, label: AppStrings.perfect(locale), value: '${profile.perfectPuzzles}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, profile, String locale) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen())),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${profile.unlockedAchievementIds.length}',
                          style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
                      Text(AppStrings.achievements(locale),
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GlassCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen())),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Text('📊', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${profile.gamesPlayed}',
                          style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
                      Text(AppStrings.gamesPlayed(locale),
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context, profile, String locale) {
    return Column(
      children: [
        _buildMenuItem(context,
          icon: Icons.emoji_events_outlined,
          title: AppStrings.achievements(locale),
          subtitle: '${profile.unlockedAchievementIds.length} / ${AchievementType.values.length} ${locale == 'pt' ? 'desbloqueadas' : locale == 'es' ? 'desbloqueados' : 'unlocked'}',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen())),
        ),
        _buildMenuItem(context,
          icon: Icons.bar_chart,
          title: AppStrings.statistics(locale),
          subtitle: locale == 'pt' ? 'Veja suas estatísticas detalhadas' : locale == 'es' ? 'Ve tus estadísticas detalladas' : 'View your detailed stats',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen())),
        ),
        _buildMenuItem(context,
          icon: Icons.settings,
          title: AppStrings.settings(locale),
          subtitle: locale == 'pt' ? 'Áudio, idioma e mais' : locale == 'es' ? 'Audio, idioma y más' : 'Audio, language, and more',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme.primaryColor.withValues(alpha: 0.2)),
              child: Icon(icon, color: AppTheme.primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, String locale) {
    final controller = TextEditingController(text: ref.read(profileProvider).username);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.editProfile(locale)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppStrings.username(locale),
            hintText: AppStrings.enterName(locale),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.cancel(locale))),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(profileProvider.notifier).updateUsername(controller.text.trim());
                ref.read(profileProvider.notifier).save();
              }
              Navigator.pop(ctx);
            },
            child: Text(AppStrings.save(locale)),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
      ],
    );
  }
}
