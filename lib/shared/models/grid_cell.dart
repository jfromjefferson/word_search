class GridCell {
  final int row;
  final int col;
  String letter;
  bool isSelected;
  bool isFound;
  bool isHinted;
  bool isInFoundWord;
  bool isPartOfSelection;
  bool isStartOfWord;
  bool isEndOfWord;

  GridCell({
    required this.row,
    required this.col,
    required this.letter,
    this.isSelected = false,
    this.isFound = false,
    this.isHinted = false,
    this.isInFoundWord = false,
    this.isPartOfSelection = false,
    this.isStartOfWord = false,
    this.isEndOfWord = false,
  });

  GridCell copyWith({
    int? row,
    int? col,
    String? letter,
    bool? isSelected,
    bool? isFound,
    bool? isHinted,
    bool? isInFoundWord,
    bool? isPartOfSelection,
    bool? isStartOfWord,
    bool? isEndOfWord,
  }) {
    return GridCell(
      row: row ?? this.row,
      col: col ?? this.col,
      letter: letter ?? this.letter,
      isSelected: isSelected ?? this.isSelected,
      isFound: isFound ?? this.isFound,
      isHinted: isHinted ?? this.isHinted,
      isInFoundWord: isInFoundWord ?? this.isInFoundWord,
      isPartOfSelection: isPartOfSelection ?? this.isPartOfSelection,
      isStartOfWord: isStartOfWord ?? this.isStartOfWord,
      isEndOfWord: isEndOfWord ?? this.isEndOfWord,
    );
  }

  void resetSelection() {
    isSelected = false;
    isPartOfSelection = false;
    isStartOfWord = false;
    isEndOfWord = false;
  }

  @override
  String toString() => 'GridCell($row,$col): $letter';
}
