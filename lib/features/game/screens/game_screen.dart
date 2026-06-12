import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/app_strings.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/constants/game_constants.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/game/providers/game_provider.dart';
import 'package:word_search/features/game/widgets/game_board.dart';
import 'package:word_search/features/game/widgets/victory_dialog.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/core/extensions/app_extensions.dart';
import 'package:word_search/shared/widgets/game_widgets.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final puzzle = gameState.puzzle;

    if (puzzle == null) {
      return Scaffold(
        backgroundColor: AppTheme.surfaceDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppTheme.primaryColor),
              const SizedBox(height: 16),
              Text(
                'Generating puzzle...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _showQuitDialog();
      },
      child: Scaffold(
        backgroundColor: AppTheme.surfaceDark,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildGameHeader(context, gameState),
                  _buildWordList(gameState),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GameBoard(
                          puzzle: puzzle,
                          currentSelection: gameState.currentSelection,
                          highlightedWords: gameState.hintHighlightedWords,
                          highlightedCell: gameState.hintHighlightedCell,
                          showHintRadar: gameState.showHintRadar,
                          onCellSelect: (row, col) {
                            ref.read(gameProvider.notifier).addToSelection(row, col);
                          },
                          onDragEnd: () {
                            ref.read(gameProvider.notifier).submitSelection();
                          },
                          onSubmitTap: () {
                            ref.read(gameProvider.notifier).submitSelection();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGameControls(context, gameState),
                  const SizedBox(height: 8),
                ],
              ),
              if (gameState.feedbackMessage != null)
                _buildFeedback(context, gameState),
              if (gameState.isPaused)
                _buildPauseOverlay(context),
              if (gameState.showVictoryDialog)
                _buildVictoryOverlay(context, gameState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameHeader(BuildContext context, GameState gameState) {
    final puzzle = gameState.puzzle!;
    final showTimer = gameState.selectedMode == GameMode.timed;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showQuitDialog(),
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: 12,
              child: const Icon(Icons.close, size: 20, color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${puzzle.wordsFoundCount}/${puzzle.totalWords} Words',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: puzzle.completionPercent / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.secondaryColor),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => ref.read(gameProvider.notifier).togglePause(),
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: 12,
              child: Icon(
                gameState.isPaused ? Icons.play_arrow : Icons.pause,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          if (showTimer) ...[
            const SizedBox(width: 8),
            _buildTimer(context, gameState),
          ],
        ],
      ),
    );
  }

  Widget _buildTimer(BuildContext context, GameState gameState) {
    final remaining = gameState.remainingSeconds;
    final isUrgent = remaining <= 30;
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 12,
      child: Row(
        children: [
          Icon(
            Icons.timer,
            size: 18,
            color: isUrgent ? AppTheme.errorColor : AppTheme.secondaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            remaining.timerFormat,
            style: TextStyle(
              color: isUrgent ? AppTheme.errorColor : AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordList(GameState gameState) {
    final puzzle = gameState.puzzle!;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: puzzle.words.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final word = puzzle.words[index];
          return WordChip(
            word: word.word,
            isFound: word.isFound,
            isSelected: word.isHinted,
          );
        },
      ),
    );
  }

  Widget _buildGameControls(BuildContext context, GameState gameState) {
    final locale = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: _HintButton(
              icon: Icons.lightbulb_outline,
              label: AppStrings.hintLetter(locale),
              onTap: () {
                ref.read(gameProvider.notifier).useHint(HintType.revealLetter);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _HintButton(
              icon: Icons.visibility_outlined,
              label: AppStrings.hintArea(locale),
              onTap: () {
                ref.read(gameProvider.notifier).useHint(HintType.highlightArea);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _HintButton(
              icon: Icons.search,
              label: AppStrings.hintReveal(locale),
              onTap: () {
                ref.read(gameProvider.notifier).useHint(HintType.revealWord);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _HintButton(
              icon: Icons.explore_outlined,
              label: AppStrings.hintRadar(locale),
              onTap: () {
                ref.read(gameProvider.notifier).useHint(HintType.directionRadar);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback(BuildContext context, GameState gameState) {
    final isError = gameState.isFeedbackError;
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Center(
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: 24,
          opacity: 0.9,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.close : Icons.check_circle,
                color: isError ? AppTheme.errorColor : AppTheme.successColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                gameState.feedbackMessage!,
                style: TextStyle(
                  color: isError ? AppTheme.errorColor : AppTheme.successColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pause_circle_outline,
                  size: 80, color: AppTheme.textPrimary),
              const SizedBox(height: 16),
              Text(
                AppStrings.gamePaused(locale),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                text: AppStrings.resume(locale),
                icon: Icons.play_arrow,
                width: 200,
                onPressed: () {
                  ref.read(gameProvider.notifier).togglePause();
                },
              ),
              const SizedBox(height: 12),
              GradientButton(
                text: AppStrings.quit(locale),
                icon: Icons.exit_to_app,
                width: 200,
                gradient: const LinearGradient(
                  colors: [AppTheme.errorColor, Color(0xFFFF5252)],
                ),
                onPressed: () {
                  ref.read(gameProvider.notifier).quitGame();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVictoryOverlay(BuildContext context, GameState gameState) {
    final puzzle = gameState.puzzle!;
    final profile = ref.watch(profileProvider);
    final difficulty = gameState.selectedDifficulty.name;
    final baseXP = GameConstants.baseXP[difficulty] ?? 100;
    final baseCoins = GameConstants.coinsPerWin[difficulty] ?? 25;

    return Positioned.fill(
      child: VictoryDialog(
        puzzle: puzzle,
        xpEarned: baseXP,
        coinsEarned: baseCoins,
        achievements: gameState.newUnlockedAchievements,
        showLevelUp: gameState.showLevelUp,
        levelsGained: gameState.levelsGained,
        newLevel: profile.level,
        onDismiss: () {
          ref.read(gameProvider.notifier).dismissVictory();
          Navigator.pop(context);
        },
        onPlayAgain: () async {
          ref.read(gameProvider.notifier).dismissVictory();
          await ref.read(gameProvider.notifier).startGame();
        },
      ),
    );
  }

  void _showQuitDialog() {
    final locale = Localizations.localeOf(context).languageCode;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.quit(locale) + '?'),
        content: Text(AppStrings.quitGameDesc(locale)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel(locale)),
          ),
          TextButton(
            onPressed: () {
              ref.read(gameProvider.notifier).quitGame();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(AppStrings.quit(locale),
                style: const TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}

class _HintButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HintButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 8),
        borderRadius: 12,
        opacity: 0.1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppTheme.warningColor),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
