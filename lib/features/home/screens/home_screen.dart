import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/app_strings.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/game/providers/game_provider.dart';
import 'package:word_search/features/game/screens/game_screen.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/features/profile/screens/profile_screen.dart';
import 'package:word_search/features/daily/screens/daily_screen.dart';
import 'package:word_search/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:word_search/features/settings/screens/settings_screen.dart';
import 'package:word_search/features/shop/screens/shop_screen.dart';
import 'package:word_search/shared/widgets/game_widgets.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final _screens = <Widget>[
    const _PlayTab(),
    const DailyScreen(),
    const ShopScreen(),
    const LeaderboardScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileProvider.notifier).handleDailyLogin();
      ref.read(profileProvider.notifier).save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.play_circle_outline),
              activeIcon: const Icon(Icons.play_circle_filled),
              label: AppStrings.play(locale),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: AppStrings.daily(locale),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.store_outlined),
              activeIcon: const Icon(Icons.store),
              label: AppStrings.shop(locale),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.leaderboard_outlined),
              activeIcon: const Icon(Icons.leaderboard),
              label: AppStrings.rank(locale),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: AppStrings.profile(locale),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayTab extends ConsumerWidget {
  const _PlayTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final gameState = ref.watch(gameProvider);
    final hasSaved = ref.watch(hasSavedGameProvider);
    final locale = Localizations.localeOf(context).languageCode;

    final categories = ThemeCategory.values.where((c) => c != ThemeCategory.mixed);
    final difficulties = Difficulty.values;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, profile, locale),
          const SizedBox(height: 20),
          _buildStatsRow(profile, locale),
          const SizedBox(height: 24),
          if (hasSaved) ...[
            _buildContinueButton(context, ref, locale),
            const SizedBox(height: 24),
          ],
          _buildQuickPlay(context, ref, gameState, locale),
          const SizedBox(height: 24),
          _buildCategoryGrid(context, ref, categories.toList(), gameState, locale),
          const SizedBox(height: 24),
          _buildDifficultySection(context, ref, difficulties, gameState, locale),
          const SizedBox(height: 24),
          _buildGameModes(context, ref, gameState, locale),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, profile, String locale) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.wordQuest(locale),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.tagline(locale),
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        CoinCounter(coins: profile.coins, compact: true),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          child: GlassContainer(
            padding: const EdgeInsets.all(8),
            borderRadius: 12,
            child: const Icon(Icons.settings_outlined, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(profile, String locale) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                XpBar(
                  currentXp: profile.xp,
                  level: profile.level,
                  progress: profile.xpProgress,
                  xpToNext: profile.xpToNextLevel,
                  compact: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    AppStrings.dayStreak(locale, profile.dailyLoginStreak),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, WidgetRef ref, String locale) {
    final gameState = ref.watch(gameProvider);
    final puzzle = gameState.puzzle;

    String subtitle = locale == 'pt' ? 'Continuar de onde parou' : locale == 'es' ? 'Continuar donde lo dejaste' : 'Continue where you left off';
    if (puzzle != null && !gameState.isPlaying) {
      subtitle = '${puzzle.category.displayNameFor(locale)} - ${puzzle.difficulty.labelFor(locale)}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale == 'pt' ? 'Jogo em Andamento' : locale == 'es' ? 'Juego en Curso' : 'Game in Progress',
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GradientButton(
          text: locale == 'pt' ? 'Continuar' : locale == 'es' ? 'Continuar' : 'Continue',
          icon: Icons.play_arrow_rounded,
          gradient: AppTheme.secondaryGradient,
          height: 56,
          onPressed: gameState.isLoading ? null : () async {
            await ref.read(gameProvider.notifier).loadGame();
            if (context.mounted) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
            }
          },
        ),
      ],
    );
  }

  Widget _buildQuickPlay(BuildContext context, WidgetRef ref, GameState gameState, String locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.quickPlay(locale),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GradientButton(
          text: gameState.isLoading
              ? AppStrings.generating(locale)
              : AppStrings.playNow(locale),
          isLoading: gameState.isLoading,
          icon: Icons.play_arrow_rounded,
          gradient: AppTheme.accentGradient,
          height: 60,
          onPressed: gameState.isLoading
              ? null
              : () => _startGame(context, ref),
        ),
      ],
    );
  }

  Future<void> _startGame(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(gameProvider.notifier);
    await notifier.startGame();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    }
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    WidgetRef ref,
    List<ThemeCategory> categories,
    GameState gameState,
    String locale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.categories(locale),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            GestureDetector(
              onTap: () {
                ref.read(gameProvider.notifier).setCategory(ThemeCategory.mixed);
              },
              child: CategoryIcon(
                category: ThemeCategory.mixed,
                selected: gameState.selectedCategory == ThemeCategory.mixed,
              ),
            ),
            ...categories.map((category) => GestureDetector(
                  onTap: () async {
                    ref.read(gameProvider.notifier).setCategory(category);
                    await _startGame(context, ref);
                  },
                  child: CategoryIcon(
                    category: category,
                    selected: gameState.selectedCategory == category && gameState.isLoading,
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultySection(
    BuildContext context,
    WidgetRef ref,
    List<Difficulty> difficulties,
    GameState gameState,
    String locale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.difficulty(locale),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: difficulties.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, index) {
              final difficulty = difficulties[index];
              final isSelected = gameState.selectedDifficulty == difficulty;
              return GestureDetector(
                onTap: () {
                  ref.read(gameProvider.notifier).setDifficulty(difficulty);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: isSelected ? AppTheme.primaryGradient : null,
                    color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      difficulty.labelFor(locale),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGameModes(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    String locale,
  ) {
    final modes = [
      (GameMode.classic, Icons.extension_outlined, AppTheme.primaryGradient),
      (GameMode.timed, Icons.timer_outlined, AppTheme.secondaryGradient),
      (GameMode.relax, Icons.self_improvement, AppTheme.accentGradient),
      (GameMode.endless, Icons.all_inclusive, AppTheme.goldGradient),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.gameModes(locale),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...modes.map((mode) {
          final (gameMode, icon, gradient) = mode;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              onTap: () async {
                ref.read(gameProvider.notifier).setMode(gameMode);
                await _startGame(context, ref);
              },
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: gradient,
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gameMode.labelFor(locale),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          gameMode.descFor(locale),
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
