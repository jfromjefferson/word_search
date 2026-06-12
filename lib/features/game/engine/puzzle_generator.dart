import 'dart:math';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/constants/game_constants.dart';
import 'package:word_search/shared/models/grid_cell.dart';
import 'package:word_search/shared/models/placed_word.dart';
import 'package:word_search/shared/models/puzzle.dart';

class PuzzleGenerator {
  final Random _random;

  PuzzleGenerator({int? seed}) : _random = Random(seed ?? DateTime.now().millisecondsSinceEpoch);

  Puzzle generate({
    required Difficulty difficulty,
    required ThemeCategory category,
    required GameMode gameMode,
    required List<String> wordPool,
  }) {
    final gridSize = GameConstants.gridSizes[difficulty.name] ?? 10;
    final minWords = GameConstants.minWords[difficulty.name] ?? 8;
    final maxWords = GameConstants.maxWords[difficulty.name] ?? 12;

    final targetWordCount = minWords + _random.nextInt(maxWords - minWords + 1);

    final candidates = _filterAndSelectWords(wordPool, gridSize, targetWordCount);

    final grid = _createEmptyGrid(gridSize);
    final allDirections = WordDirection.values;

    final placedWords = <PlacedWord>[];

    for (final word in candidates) {
      final direction = allDirections[_random.nextInt(allDirections.length)];
      final placements = _findAllPlacements(word, gridSize, direction, grid);

      if (placements.isNotEmpty) {
        final (startRow, startCol) = placements[_random.nextInt(placements.length)];
        _placeWordOnGrid(grid, word, startRow, startCol, direction, gridSize);
        placedWords.add(PlacedWord(
          word: word,
          startRow: startRow,
          startCol: startCol,
          direction: direction,
        ));
      }
    }

    _fillEmptyCells(grid, gridSize);

    final id = '${difficulty.name}_${category.name}_${DateTime.now().millisecondsSinceEpoch}';

    return Puzzle(
      id: id,
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
      gridSize: gridSize,
      grid: grid,
      words: placedWords,
      totalWords: placedWords.length,
      startTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  List<String> _filterAndSelectWords(
    List<String> wordPool,
    int gridSize,
    int targetCount,
  ) {
    final maxLen = gridSize;
    final valid = wordPool
        .where((w) =>
            w.length >= GameConstants.minWordLength &&
            w.length <= maxLen)
        .toList();

    valid.shuffle(_random);

    final selected = <String>[];
    final usedLetters = <String>{};
    for (final word in valid) {
      if (selected.length >= targetCount) break;
      final upperWord = word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
      if (upperWord.length < GameConstants.minWordLength) continue;
      if (!selected.contains(upperWord)) {
        selected.add(upperWord);
        usedLetters.addAll(upperWord.split(''));
      }
    }

    selected.sort((a, b) => b.length.compareTo(a.length));
    return selected;
  }

  List<GridCell> _createEmptyGrid(int size) {
    return List.generate(
      size * size,
      (i) => GridCell(
        row: i ~/ size,
        col: i % size,
        letter: '',
      ),
    );
  }

  List<(int, int)> _findAllPlacements(
    String word,
    int gridSize,
    WordDirection direction,
    List<GridCell> grid,
  ) {
    final (dr, dc) = direction.delta;
    final wordLen = word.length;
    final placements = <(int, int)>[];

    final maxStartRow = gridSize - 1 - (dr * (wordLen - 1));
    final maxStartCol = gridSize - 1 - (dc * (wordLen - 1));
    final minStartRow = dc < 0 ? (wordLen - 1) : 0;
    final minStartCol = dr < 0 ? (wordLen - 1) : 0;

    for (int row = minStartRow; row <= maxStartRow; row++) {
      for (int col = minStartCol; col <= maxStartCol; col++) {
        if (_canPlaceWord(grid, gridSize, word, row, col, dr, dc)) {
          placements.add((row, col));
        }
      }
    }

    return placements;
  }

  bool _canPlaceWord(
    List<GridCell> grid,
    int gridSize,
    String word,
    int startRow,
    int startCol,
    int dr,
    int dc,
  ) {
    for (int i = 0; i < word.length; i++) {
      final row = startRow + dr * i;
      final col = startCol + dc * i;

      if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) {
        return false;
      }

      final existing = grid[row * gridSize + col].letter;
      if (existing.isNotEmpty && existing != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _placeWordOnGrid(
    List<GridCell> grid,
    String word,
    int startRow,
    int startCol,
    WordDirection direction,
    int gridSize,
  ) {
    final (dr, dc) = direction.delta;
    for (int i = 0; i < word.length; i++) {
      final row = startRow + dr * i;
      final col = startCol + dc * i;
      grid[row * gridSize + col].letter = word[i];
    }
  }

  void _fillEmptyCells(List<GridCell> grid, int gridSize) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < grid.length; i++) {
      if (grid[i].letter.isEmpty) {
        grid[i].letter = letters[_random.nextInt(letters.length)];
      }
    }
  }

  static (int, int)? findWordOnGrid(
    List<GridCell> grid,
    int gridSize,
    List<(int, int)> selectedCells,
    List<PlacedWord> placedWords,
  ) {
    if (selectedCells.length < GameConstants.minWordLength) return null;

    final selectedString = selectedCells.map((e) {
      final (r, c) = e;
      return grid[r * gridSize + c].letter;
    }).join();

    final reversedString = selectedString.split('').reversed.join();

    for (int i = 0; i < placedWords.length; i++) {
      final word = placedWords[i];
      if (word.isFound) continue;
      if (word.word == selectedString || word.word == reversedString) {
        final (dr, dc) = word.direction.delta;
        final expectedStart = (word.startRow, word.startCol);
        final forwardStart = selectedCells.first;
        final reverseStart = selectedCells.last;

        final matchesForward =
            forwardStart == expectedStart &&
            selectedCells.length == word.length &&
            _checkContinuous(selectedCells, dr, dc);

        final matchesReverse =
            reverseStart == expectedStart &&
            selectedCells.length == word.length &&
            _checkContinuousReversed(selectedCells, dr, dc);

        if (matchesForward || matchesReverse) {
          return (i, 0);
        }
      }
    }

    return null;
  }

  static bool _checkContinuous(List<(int, int)> cells, int dr, int dc) {
    for (int i = 1; i < cells.length; i++) {
      final (r1, c1) = cells[i - 1];
      final (r2, c2) = cells[i];
      if (r2 - r1 != dr || c2 - c1 != dc) return false;
    }
    return true;
  }

  static bool _checkContinuousReversed(List<(int, int)> cells, int dr, int dc) {
    for (int i = 1; i < cells.length; i++) {
      final (r1, c1) = cells[i - 1];
      final (r2, c2) = cells[i];
      if (r2 - r1 != -dr || c2 - c1 != -dc) return false;
    }
    return true;
  }

  static Difficulty suggestDifficulty({
    required double accuracy,
    required double avgCompletionTimeMs,
    required int consecutiveVictories,
    required int totalPuzzlesCompleted,
  }) {
    if (totalPuzzlesCompleted < 3) return Difficulty.easy;

    int score = 0;

    if (accuracy >= 95) score += 2;
    else if (accuracy >= 80) score += 1;

    if (avgCompletionTimeMs < 60000) score += 2;
    else if (avgCompletionTimeMs < 120000) score += 1;

    if (consecutiveVictories >= 5) score += 2;
    else if (consecutiveVictories >= 3) score += 1;

    if (totalPuzzlesCompleted >= 50) score += 1;

    if (score >= 6) return Difficulty.master;
    if (score >= 4) return Difficulty.hard;
    if (score >= 2) return Difficulty.medium;
    return Difficulty.easy;
  }
}
