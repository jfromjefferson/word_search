import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/app_strings.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/constants/game_constants.dart';
import 'package:word_search/core/services/audio_manager.dart';
import 'package:word_search/core/services/word_list_service.dart';
import 'package:word_search/features/game/engine/puzzle_generator.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/features/settings/settings_provider.dart';
import 'package:word_search/shared/models/placed_word.dart';
import 'package:word_search/shared/models/puzzle.dart';

class GameState {
  final Puzzle? puzzle;
  final bool isLoading;
  final bool isPlaying;
  final bool isPaused;
  final bool isCompleted;
  final String? error;
  final Difficulty selectedDifficulty;
  final ThemeCategory selectedCategory;
  final GameMode selectedMode;
  final List<(int, int)> currentSelection;
  final int elapsedSeconds;
  final int remainingSeconds;
  final String? feedbackMessage;
  final bool isFeedbackError;
  final List<String> newUnlockedAchievements;
  final bool showVictoryDialog;
  final bool showLevelUp;
  final int levelsGained;
  final List<PlacedWord>? hintHighlightedWords;
  final (int, int)? hintHighlightedCell;
  final bool showHintRadar;

  const GameState({
    this.puzzle,
    this.isLoading = false,
    this.isPlaying = false,
    this.isPaused = false,
    this.isCompleted = false,
    this.error,
    this.selectedDifficulty = Difficulty.medium,
    this.selectedCategory = ThemeCategory.mixed,
    this.selectedMode = GameMode.classic,
    this.currentSelection = const [],
    this.elapsedSeconds = 0,
    this.remainingSeconds = 0,
    this.feedbackMessage,
    this.isFeedbackError = false,
    this.newUnlockedAchievements = const [],
    this.showVictoryDialog = false,
    this.showLevelUp = false,
    this.levelsGained = 0,
    this.hintHighlightedWords,
    this.hintHighlightedCell,
    this.showHintRadar = false,
  });

  GameState copyWith({
    Puzzle? puzzle,
    bool? isLoading,
    bool? isPlaying,
    bool? isPaused,
    bool? isCompleted,
    String? error,
    Difficulty? selectedDifficulty,
    ThemeCategory? selectedCategory,
    GameMode? selectedMode,
    List<(int, int)>? currentSelection,
    int? elapsedSeconds,
    int? remainingSeconds,
    String? feedbackMessage,
    bool? isFeedbackError,
    List<String>? newUnlockedAchievements,
    bool? showVictoryDialog,
    bool? showLevelUp,
    int? levelsGained,
    List<PlacedWord>? hintHighlightedWords,
    (int, int)? hintHighlightedCell,
    bool? showHintRadar,
    bool clearFeedback = false,
    bool clearHint = false,
    bool clearAchievements = false,
  }) {
    return GameState(
      puzzle: puzzle ?? this.puzzle,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error ?? this.error,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedMode: selectedMode ?? this.selectedMode,
      currentSelection: currentSelection ?? this.currentSelection,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      feedbackMessage:
          clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
      isFeedbackError: isFeedbackError ?? this.isFeedbackError,
      newUnlockedAchievements: clearAchievements
          ? []
          : (newUnlockedAchievements ?? this.newUnlockedAchievements),
      showVictoryDialog: showVictoryDialog ?? this.showVictoryDialog,
      showLevelUp: showLevelUp ?? this.showLevelUp,
      levelsGained: levelsGained ?? this.levelsGained,
      hintHighlightedWords:
          clearHint ? null : (hintHighlightedWords ?? this.hintHighlightedWords),
      hintHighlightedCell:
          clearHint ? null : (hintHighlightedCell ?? this.hintHighlightedCell),
      showHintRadar:
          clearHint ? false : (showHintRadar ?? this.showHintRadar),
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  final Ref _ref;
  final AudioManager _audio;
  Timer? _timer;

  String get _locale => _ref.read(settingsProvider).language;

  GameNotifier(this._ref)
      : _audio = AudioManager(),
        super(const GameState());

  void setDifficulty(Difficulty difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
  }

  void setCategory(ThemeCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setMode(GameMode mode) {
    state = state.copyWith(selectedMode: mode);
  }

  Future<void> startGame() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final wordService = WordListService();
      final locale = _ref.read(settingsProvider).language;
      final wordPool = await wordService.getWords(state.selectedCategory, locale: locale);

      final generator = PuzzleGenerator();
      final puzzle = generator.generate(
        difficulty: state.selectedDifficulty,
        category: state.selectedCategory,
        gameMode: state.selectedMode,
        wordPool: wordPool,
      );

      final totalSeconds = GameConstants.timerSeconds[state.selectedDifficulty.name] ?? 300;

      state = state.copyWith(
        puzzle: puzzle,
        isLoading: false,
        isPlaying: true,
        isPaused: false,
        isCompleted: false,
        currentSelection: [],
        elapsedSeconds: 0,
        remainingSeconds: state.selectedMode == GameMode.timed ? totalSeconds : 0,
        error: null,
        showVictoryDialog: false,
        clearFeedback: true,
        clearHint: true,
        clearAchievements: true,
      );

      if (state.selectedMode == GameMode.timed) {
        _startTimer();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '${AppStrings.puzzleError(_locale)} $e',
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPlaying || state.isPaused) return;

      final newElapsed = state.elapsedSeconds + 1;
      final newRemaining = state.remainingSeconds - 1;

      if (newRemaining <= 0 && state.selectedMode == GameMode.timed) {
        _timer?.cancel();
        _handleTimeUp();
        return;
      }

      state = state.copyWith(
        elapsedSeconds: newElapsed,
        remainingSeconds: newRemaining,
      );
    });
  }

  void _handleTimeUp() {
    _ref.read(profileProvider.notifier).recordDefeat();
    state = state.copyWith(
      isPlaying: false,
      isCompleted: true,
    );
  }

  void togglePause() {
    if (!state.isPlaying) return;
    state = state.copyWith(isPaused: !state.isPaused);
    _audio.playButtonTap();
  }

  void addToSelection(int row, int col) {
    if (!state.isPlaying || state.isPaused) return;
    final puzzle = state.puzzle;
    if (puzzle == null) return;

    final selection = List<(int, int)>.from(state.currentSelection);

    if (selection.isEmpty) {
      selection.add((row, col));
      state = state.copyWith(currentSelection: selection);
      _audio.playSelect();
      return;
    }

    final idx = selection.indexOf((row, col));
    if (idx >= 0) {
      if (idx == selection.length - 1) return;
      selection.removeRange(idx + 1, selection.length);
      state = state.copyWith(currentSelection: selection);
      _audio.playSelect();
      return;
    }

    final last = selection.last;
    final (lr, lc) = last;
    final dr = (row - lr).abs();
    final dc = (col - lc).abs();

    if (dr > 1 || dc > 1 || (dr == 0 && dc == 0)) return;

    if (selection.length >= 2) {
      final prev = selection[selection.length - 2];
      final (pr, pc) = prev;
      final expectedDr = lr - pr;
      final expectedDc = lc - pc;
      if (row - lr != expectedDr || col - lc != expectedDc) return;
    }

    selection.add((row, col));
    state = state.copyWith(currentSelection: selection);
    _audio.playSelect();
  }

  void clearSelection() {
    if (state.currentSelection.isEmpty) return;
    state = state.copyWith(currentSelection: []);
  }

  void submitSelection() {
    final puzzle = state.puzzle;
    if (puzzle == null || state.currentSelection.length < 3) {
      return;
    }

    final result = PuzzleGenerator.findWordOnGrid(
      puzzle.grid,
      puzzle.gridSize,
      state.currentSelection,
      puzzle.words,
    );

    if (result != null) {
      final (wordIndex, _) = result;
      final foundWord = puzzle.words[wordIndex];
      foundWord.isFound = true;

      final newWordsFound = List<WordsFound>.from(puzzle.wordsFound);
      newWordsFound.add(WordsFound(
        word: foundWord.word,
        direction: foundWord.direction,
        timeFound: DateTime.now().millisecondsSinceEpoch,
      ));

      final newWordsFoundCount = puzzle.wordsFoundCount + 1;
      final allFound = newWordsFoundCount >= puzzle.totalWords;

      for (final (r, c) in foundWord.positions) {
        puzzle.getCell(r, c).isFound = true;
        puzzle.getCell(r, c).isInFoundWord = true;
        puzzle.getCell(r, c).isSelected = true;
      }

      _ref.read(profileProvider.notifier).recordWordFound(
            foundWord.word,
            puzzle.category.name,
          );

      _audio.playWordFound();

      final updatedPuzzle = puzzle.copyWith(
        wordsFound: newWordsFound,
        wordsFoundCount: newWordsFoundCount,
        isCompleted: allFound,
        endTime: allFound ? DateTime.now().millisecondsSinceEpoch : puzzle.endTime,
        perfect: allFound ? (puzzle.hintsUsed == 0 && puzzle.mistakes == 0) : false,
      );

      state = state.copyWith(
        puzzle: updatedPuzzle,
        currentSelection: [],
        feedbackMessage: AppStrings.wordFoundMsg(_locale, foundWord.word),
        isFeedbackError: false,
        clearHint: true,
      );

      if (allFound) {
        _handleVictory(updatedPuzzle);
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          state = state.copyWith(clearFeedback: true);
        }
      });
    } else {
      final newMistakes = puzzle.mistakes + 1;
      state = state.copyWith(
        puzzle: puzzle.copyWith(mistakes: newMistakes),
        currentSelection: [],
        feedbackMessage: AppStrings.tryAgain(_locale),
        isFeedbackError: true,
      );

      _audio.playError();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          state = state.copyWith(clearFeedback: true);
        }
      });
    }
  }

  void _handleVictory(Puzzle puzzle) {
    _timer?.cancel();

    _ref.read(storageServiceProvider).clearPuzzle();
    _ref.read(hasSavedGameProvider.notifier).state = false;

    final profileNotifier = _ref.read(profileProvider.notifier);
    final difficulty = puzzle.difficulty.name;
    final completionTimeMs = (puzzle.endTime! - puzzle.startTime);
    final perfect = puzzle.hintsUsed == 0 && puzzle.mistakes == 0;

    final baseXP = GameConstants.baseXP[difficulty] ?? 100;
    int xpEarned = baseXP;
    if (perfect) xpEarned += GameConstants.perfectCompletionBonus;
    if (completionTimeMs < 60000) xpEarned += GameConstants.fastCompletionBonus;
    xpEarned -= puzzle.hintsUsed * GameConstants.hintPenalty;

    final baseCoins = GameConstants.coinsPerWin[difficulty] ?? 25;

    final oldLevel = profileNotifier.state.level;

    profileNotifier.recordPuzzleCompleted(
      difficulty: difficulty,
      completionTimeMs: completionTimeMs,
      perfect: perfect,
      hintsUsed: puzzle.hintsUsed,
      fastCompletionMs: 60000,
    );
    profileNotifier.addXP(xpEarned);
    profileNotifier.addCoins(baseCoins);
    profileNotifier.save();

    final newLevel = profileNotifier.state.level;
    final levelsGained = newLevel - oldLevel;

    final achievements = _checkAchievements(profileNotifier, puzzle);

    _audio.playVictory();

    state = state.copyWith(
      isPlaying: false,
      isCompleted: true,
      showVictoryDialog: true,
      newUnlockedAchievements: achievements,
      showLevelUp: levelsGained > 0,
      levelsGained: levelsGained,
    );
  }

  List<String> _checkAchievements(
    ProfileNotifier profile,
    Puzzle puzzle,
  ) {
    final ids = <String>[];
    final p = profile.state;

    void check(String id) {
      if (!p.unlockedAchievementIds.contains(id)) {
        profile.unlockAchievement(id);
        ids.add(id);
      }
    }

    if (p.totalPuzzlesCompleted >= 1) {
      check(AchievementType.firstVictory.name);
    }
    if (p.totalPuzzlesCompleted >= 10) {
      check(AchievementType.tenPuzzles.name);
    }
    if (p.totalWordsFound >= 100) {
      check(AchievementType.hundredWords.name);
    }
    if (p.dailyLoginStreak >= 7) {
      check(AchievementType.sevenDayStreak.name);
    }
    if (p.perfectPuzzles >= 1) {
      check(AchievementType.perfectPuzzle.name);
    }
    if (p.bestCompletionTimeMs > 0 && p.bestCompletionTimeMs < 60000) {
      check(AchievementType.speedMaster.name);
    }
    if (p.totalPuzzlesCompleted >= 50) {
      check(AchievementType.puzzleLegend.name);
    }
    if (p.level >= 10) {
      check(AchievementType.levelTen.name);
    }
    if (p.level >= 25) {
      check(AchievementType.levelTwentyFive.name);
    }
    if (p.level >= 50) {
      check(AchievementType.levelFifty.name);
    }
    if (p.coinsEarned >= 1000) {
      check(AchievementType.coinCollector.name);
    }
    if (p.wordsPerCategory.length >= 10) {
      check(AchievementType.allCategories.name);
    }
    if (p.totalWordsFound >= 500) {
      check(AchievementType.wordHunter.name);
    }

    return ids;
  }

  void useHint(HintType hintType) {
    final puzzle = state.puzzle;
    if (puzzle == null || !state.isPlaying) return;

    final profile = _ref.read(profileProvider.notifier);
    if (profile.state.coins < 25) return;

    profile.spendCoins(25);
    _audio.playHint();

    final newHintsUsed = puzzle.hintsUsed + 1;

    switch (hintType) {
      case HintType.revealLetter:
        final remaining = puzzle.remainingWords;
        if (remaining.isEmpty) return;
        final word = remaining[Random().nextInt(remaining.length)];
        final pos = word.positions[Random().nextInt(word.length)];
        final cell = puzzle.getCell(pos.$1, pos.$2);
        cell.isHinted = true;
        state = state.copyWith(
          puzzle: puzzle.copyWith(hintsUsed: newHintsUsed),
          hintHighlightedCell: pos,
        );
      case HintType.revealWord:
        final remaining = puzzle.remainingWords;
        if (remaining.isEmpty) return;
        final word = remaining[Random().nextInt(remaining.length)];
        word.isFound = true;
        for (final (r, c) in word.positions) {
          puzzle.getCell(r, c).isFound = true;
          puzzle.getCell(r, c).isInFoundWord = true;
        }
        final newWordsFound = List<WordsFound>.from(puzzle.wordsFound);
        newWordsFound.add(WordsFound(
          word: word.word,
          direction: word.direction,
          timeFound: DateTime.now().millisecondsSinceEpoch,
        ));
        final newCount = puzzle.wordsFoundCount + 1;
        final allFound = newCount >= puzzle.totalWords;
        final updatedPuzzle = puzzle.copyWith(
          hintsUsed: newHintsUsed,
          wordsFound: newWordsFound,
          wordsFoundCount: newCount,
          isCompleted: allFound,
          endTime: allFound ? DateTime.now().millisecondsSinceEpoch : puzzle.endTime,
        );
        state = state.copyWith(puzzle: updatedPuzzle);
        if (allFound) _handleVictory(updatedPuzzle);
      case HintType.highlightArea:
        final remaining = puzzle.remainingWords;
        if (remaining.isEmpty) return;
        final word = remaining[Random().nextInt(remaining.length)];
        state = state.copyWith(
          puzzle: puzzle.copyWith(hintsUsed: newHintsUsed),
          hintHighlightedWords: [word],
        );
      case HintType.directionRadar:
        state = state.copyWith(
          puzzle: puzzle.copyWith(hintsUsed: newHintsUsed),
          showHintRadar: true,
        );
    }

    profile.save();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        state = state.copyWith(clearHint: true);
      }
    });
  }

  void dismissVictory() {
    state = state.copyWith(
      showVictoryDialog: false,
      showLevelUp: false,
      clearAchievements: true,
    );
  }

  void quitGame() {
    _savePuzzle();
    _timer?.cancel();
    state = const GameState();
  }

  void quitWithoutSaving() {
    _ref.read(storageServiceProvider).clearPuzzle();
    _ref.read(hasSavedGameProvider.notifier).state = false;
    _timer?.cancel();
    state = const GameState();
  }

  void _savePuzzle() {
    final puzzle = state.puzzle;
    if (puzzle == null || puzzle.isCompleted) return;
    _ref.read(storageServiceProvider).savePuzzle(puzzle.toJson());
    _ref.read(hasSavedGameProvider.notifier).state = true;
  }

  Future<void> loadGame() async {
    final storage = _ref.read(storageServiceProvider);
    final data = await storage.loadPuzzle();
    if (data == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final puzzle = Puzzle.fromJson(data);
      final totalSeconds = GameConstants.timerSeconds[puzzle.difficulty.name] ?? 300;
      final elapsed = DateTime.now().millisecondsSinceEpoch - puzzle.startTime;
      final remaining = puzzle.gameMode == GameMode.timed
          ? ((totalSeconds * 1000) - elapsed) ~/ 1000
          : 0;

      state = state.copyWith(
        puzzle: puzzle,
        isLoading: false,
        isPlaying: true,
        isPaused: false,
        isCompleted: false,
        selectedDifficulty: puzzle.difficulty,
        selectedCategory: puzzle.category,
        selectedMode: puzzle.gameMode,
        currentSelection: [],
        elapsedSeconds: elapsed ~/ 1000,
        remainingSeconds: remaining > 0 ? remaining : 0,
        showVictoryDialog: false,
        clearFeedback: true,
        clearHint: true,
        clearAchievements: true,
      );

      if (puzzle.gameMode == GameMode.timed && remaining > 0) {
        _startTimer();
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref);
});

final hasSavedGameProvider = StateProvider<bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.hasSavedPuzzle;
});
