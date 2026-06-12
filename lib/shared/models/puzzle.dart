import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/shared/models/grid_cell.dart';
import 'package:word_search/shared/models/placed_word.dart';

class Puzzle {
  final String id;
  final Difficulty difficulty;
  final ThemeCategory category;
  final GameMode gameMode;
  final int gridSize;
  final List<GridCell> grid;
  final List<PlacedWord> words;
  final List<WordsFound> wordsFound;
  final int totalWords;
  final int wordsFoundCount;
  final int hintsUsed;
  final int mistakes;
  final int startTime;
  final int? endTime;
  final bool isCompleted;
  final int score;
  final bool perfect;

  const Puzzle({
    required this.id,
    required this.difficulty,
    required this.category,
    required this.gameMode,
    required this.gridSize,
    required this.grid,
    required this.words,
    this.wordsFound = const [],
    this.totalWords = 0,
    this.wordsFoundCount = 0,
    this.hintsUsed = 0,
    this.mistakes = 0,
    this.startTime = 0,
    this.endTime,
    this.isCompleted = false,
    this.score = 0,
    this.perfect = false,
  });

  int get gridWidth => gridSize;
  int get gridHeight => gridSize;

  GridCell getCell(int row, int col) => grid[row * gridSize + col];

  int getCellIndex(int row, int col) => row * gridSize + col;

  List<PlacedWord> get remainingWords =>
      words.where((w) => !w.isFound).toList();

  List<PlacedWord> get foundWords => words.where((w) => w.isFound).toList();

  int get completionPercent =>
      totalWords > 0 ? ((wordsFoundCount / totalWords) * 100).round() : 0;

  Duration? get completionTime =>
      endTime != null ? Duration(milliseconds: endTime! - startTime) : null;

  int get elapsedMs =>
      DateTime.now().millisecondsSinceEpoch - startTime;

  Puzzle copyWith({
    String? id,
    Difficulty? difficulty,
    ThemeCategory? category,
    GameMode? gameMode,
    int? gridSize,
    List<GridCell>? grid,
    List<PlacedWord>? words,
    List<WordsFound>? wordsFound,
    int? totalWords,
    int? wordsFoundCount,
    int? hintsUsed,
    int? mistakes,
    int? startTime,
    int? endTime,
    bool? isCompleted,
    int? score,
    bool? perfect,
  }) {
    return Puzzle(
      id: id ?? this.id,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      gameMode: gameMode ?? this.gameMode,
      gridSize: gridSize ?? this.gridSize,
      grid: grid ?? this.grid,
      words: words ?? this.words,
      wordsFound: wordsFound ?? this.wordsFound,
      totalWords: totalWords ?? this.totalWords,
      wordsFoundCount: wordsFoundCount ?? this.wordsFoundCount,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      mistakes: mistakes ?? this.mistakes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      perfect: perfect ?? this.perfect,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'difficulty': difficulty.name,
        'category': category.name,
        'gameMode': gameMode.name,
        'gridSize': gridSize,
        'grid': grid.map((c) => c.letter).toList(),
        'words': words.map((w) => w.toJson()).toList(),
        'wordsFound': wordsFound.map((w) => w.toJson()).toList(),
        'totalWords': totalWords,
        'wordsFoundCount': wordsFoundCount,
        'hintsUsed': hintsUsed,
        'mistakes': mistakes,
        'startTime': startTime,
        'endTime': endTime,
        'isCompleted': isCompleted,
        'score': score,
        'perfect': perfect,
      };

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    final gridSize = json['gridSize'] as int;
    final gridLetters = List<String>.from(json['grid'] as List);
    final grid = List.generate(
      gridSize * gridSize,
      (i) => GridCell(
        row: i ~/ gridSize,
        col: i % gridSize,
        letter: gridLetters[i],
      ),
    );
    final wordsList = (json['words'] as List)
        .map((w) => PlacedWord.fromJson(Map<String, dynamic>.from(w as Map)))
        .toList();

    return Puzzle(
      id: json['id'] as String,
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      category: ThemeCategory.values.byName(json['category'] as String),
      gameMode: GameMode.values.byName(json['gameMode'] as String),
      gridSize: gridSize,
      grid: grid,
      words: wordsList,
      wordsFound: (json['wordsFound'] as List? ?? [])
          .map((w) =>
              WordsFound.fromJson(Map<String, dynamic>.from(w as Map)))
          .toList(),
      totalWords: json['totalWords'] as int? ?? wordsList.length,
      wordsFoundCount: json['wordsFoundCount'] as int? ?? 0,
      hintsUsed: json['hintsUsed'] as int? ?? 0,
      mistakes: json['mistakes'] as int? ?? 0,
      startTime: json['startTime'] as int? ?? 0,
      endTime: json['endTime'] as int?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      perfect: json['perfect'] as bool? ?? false,
    );
  }
}
