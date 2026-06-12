import 'package:word_search/core/constants/enums.dart';

class PlacedWord {
  final String word;
  final int startRow;
  final int startCol;
  final WordDirection direction;
  bool isFound;
  bool isHinted;

  PlacedWord({
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.direction,
    this.isFound = false,
    this.isHinted = false,
  });

  int get endRow {
    final (dr, dc) = direction.delta;
    return startRow + dr * (word.length - 1);
  }

  int get endCol {
    final (dr, dc) = direction.delta;
    return startCol + dc * (word.length - 1);
  }

  List<(int, int)> get positions {
    final (dr, dc) = direction.delta;
    return List.generate(
      word.length,
      (i) => (startRow + dr * i, startCol + dc * i),
    );
  }

  bool occupiesPosition(int row, int col) {
    for (final (r, c) in positions) {
      if (r == row && c == col) return true;
    }
    return false;
  }

  int get length => word.length;

  WordsFound toFound() => WordsFound(
        word: word,
        direction: direction,
        timeFound: DateTime.now().millisecondsSinceEpoch,
      );

  Map<String, dynamic> toJson() => {
        'word': word,
        'startRow': startRow,
        'startCol': startCol,
        'direction': direction.name,
        'isFound': isFound,
        'isHinted': isHinted,
      };

  factory PlacedWord.fromJson(Map<String, dynamic> json) => PlacedWord(
        word: json['word'] as String,
        startRow: json['startRow'] as int,
        startCol: json['startCol'] as int,
        direction: WordDirection.values.byName(json['direction'] as String),
        isFound: json['isFound'] as bool? ?? false,
        isHinted: json['isHinted'] as bool? ?? false,
      );
}

class WordsFound {
  final String word;
  final WordDirection direction;
  final int timeFound;

  const WordsFound({
    required this.word,
    required this.direction,
    required this.timeFound,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'direction': direction.name,
        'timeFound': timeFound,
      };

  factory WordsFound.fromJson(Map<String, dynamic> json) => WordsFound(
        word: json['word'] as String,
        direction: WordDirection.values.byName(json['direction'] as String),
        timeFound: json['timeFound'] as int,
      );
}
