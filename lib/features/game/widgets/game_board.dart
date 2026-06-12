import 'package:flutter/material.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/shared/models/grid_cell.dart';
import 'package:word_search/shared/models/placed_word.dart';
import 'package:word_search/shared/models/puzzle.dart';

class GameBoard extends StatefulWidget {
  final Puzzle puzzle;
  final List<(int, int)> currentSelection;
  final List<PlacedWord>? highlightedWords;
  final (int, int)? highlightedCell;
  final bool showHintRadar;
  final void Function(int row, int col) onCellSelect;
  final VoidCallback onDragEnd;
  final VoidCallback? onSubmitTap;

  const GameBoard({
    super.key,
    required this.puzzle,
    required this.currentSelection,
    this.highlightedWords,
    this.highlightedCell,
    this.showHintRadar = false,
    required this.onCellSelect,
    required this.onDragEnd,
    this.onSubmitTap,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  bool _wasDrag = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxSize = screenWidth - 24;
    final cellSize = (maxSize / widget.puzzle.gridSize).floorToDouble().clamp(24.0, 48.0);
    final boardSize = cellSize * widget.puzzle.gridSize;

    return GestureDetector(
      onTap: () {
        if (widget.currentSelection.isNotEmpty) {
          widget.onSubmitTap?.call();
        }
      },
      onPanStart: (details) {
        _wasDrag = false;
        final cell = _getCellFromPosition(details.localPosition, cellSize);
        if (cell != null) widget.onCellSelect(cell.$1, cell.$2);
      },
      onPanUpdate: (details) {
        _wasDrag = true;
        final cell = _getCellFromPosition(details.localPosition, cellSize);
        if (cell != null) widget.onCellSelect(cell.$1, cell.$2);
      },
      onPanEnd: (_) {
        if (_wasDrag) {
          widget.onDragEnd();
        }
      },
      child: Container(
        width: boardSize,
        height: boardSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
          color: AppTheme.surfaceMedium.withValues(alpha: 0.6),
        ),
        child: CustomPaint(
          painter: _SelectionPainter(
            puzzle: widget.puzzle,
            currentSelection: widget.currentSelection,
            cellSize: cellSize,
            highlightedWords: widget.highlightedWords,
            highlightedCell: widget.highlightedCell,
            showHintRadar: widget.showHintRadar,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.puzzle.gridSize,
              childAspectRatio: 1,
            ),
            itemCount: widget.puzzle.grid.length,
            itemBuilder: (context, index) {
              final cell = widget.puzzle.grid[index];
              final isSelected = widget.currentSelection.contains((cell.row, cell.col));
              final isHint = widget.highlightedCell != null &&
                  widget.highlightedCell!.$1 == cell.row &&
                  widget.highlightedCell!.$2 == cell.col;

              return _CellWidget(
                cell: cell,
                isSelected: isSelected,
                isHinted: isHint,
              );
            },
          ),
        ),
      ),
    );
  }

  (int, int)? _getCellFromPosition(Offset position, double cellSize) {
    final col = (position.dx / cellSize).floor();
    final row = (position.dy / cellSize).floor();
    if (row < 0 || row >= widget.puzzle.gridSize || col < 0 || col >= widget.puzzle.gridSize) {
      return null;
    }
    return (row, col);
  }
}

class _CellWidget extends StatelessWidget {
  final GridCell cell;
  final bool isSelected;
  final bool isHinted;

  const _CellWidget({
    required this.cell,
    required this.isSelected,
    this.isHinted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _getCellColor(),
        border: isSelected
            ? Border.all(color: AppTheme.accentColor, width: 2)
            : isHinted
                ? Border.all(color: AppTheme.warningColor, width: 2)
                : null,
        boxShadow: isHinted
            ? [
                BoxShadow(
                  color: AppTheme.warningColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: (cell.isFound) ? 1.1 : 1.0,
          child: Text(
            cell.letter,
            style: TextStyle(
              color: cell.isFound
                  ? AppTheme.successColor
                  : isSelected
                      ? Colors.white
                      : AppTheme.textPrimary,
              fontSize: isSelected ? 18 : 16,
              fontWeight:
                  cell.isFound || isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Color _getCellColor() {
    if (cell.isFound) {
      return AppTheme.successColor.withValues(alpha: 0.15);
    }
    if (isSelected) {
      return AppTheme.accentColor.withValues(alpha: 0.25);
    }
    if (isHinted) {
      return AppTheme.warningColor.withValues(alpha: 0.2);
    }
    return Colors.transparent;
  }
}

class _SelectionPainter extends CustomPainter {
  final Puzzle puzzle;
  final List<(int, int)> currentSelection;
  final double cellSize;
  final List<PlacedWord>? highlightedWords;
  final (int, int)? highlightedCell;
  final bool showHintRadar;

  _SelectionPainter({
    required this.puzzle,
    required this.currentSelection,
    required this.cellSize,
    this.highlightedWords,
    this.highlightedCell,
    this.showHintRadar = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawFoundWords(canvas);
    _drawSelectionLine(canvas);
    _drawHighlightedWords(canvas);
    _drawHintRadar(canvas);
  }

  void _drawFoundWords(Canvas canvas) {
    for (final word in puzzle.words) {
      if (!word.isFound) continue;
      final paint = Paint()
        ..color = AppTheme.successColor.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill
        ..strokeWidth = cellSize * 0.6
        ..strokeCap = StrokeCap.round;

      final start = word.positions.first;
      final end = word.positions.last;
      final startOffset = Offset(
        start.$2 * cellSize + cellSize / 2,
        start.$1 * cellSize + cellSize / 2,
      );
      final endOffset = Offset(
        end.$2 * cellSize + cellSize / 2,
        end.$1 * cellSize + cellSize / 2,
      );
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  void _drawSelectionLine(Canvas canvas) {
    if (currentSelection.length < 2) return;
    final paint = Paint()
      ..color = AppTheme.accentColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = cellSize * 0.4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final first = currentSelection.first;
    path.moveTo(
      first.$2 * cellSize + cellSize / 2,
      first.$1 * cellSize + cellSize / 2,
    );
    for (int i = 1; i < currentSelection.length; i++) {
      final (row, col) = currentSelection[i];
      path.lineTo(
        col * cellSize + cellSize / 2,
        row * cellSize + cellSize / 2,
      );
    }
    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = AppTheme.accentColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (final (row, col) in currentSelection) {
      canvas.drawCircle(
        Offset(col * cellSize + cellSize / 2, row * cellSize + cellSize / 2),
        cellSize * 0.15,
        dotPaint,
      );
    }
  }

  void _drawHighlightedWords(Canvas canvas) {
    if (highlightedWords == null) return;
    for (final word in highlightedWords!) {
      final paint = Paint()
        ..color = AppTheme.warningColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = cellSize * 0.5
        ..strokeCap = StrokeCap.round;

      final positions = word.positions;
      final start = positions.first;
      final end = positions.last;
      canvas.drawLine(
        Offset(start.$2 * cellSize + cellSize / 2, start.$1 * cellSize + cellSize / 2),
        Offset(end.$2 * cellSize + cellSize / 2, end.$1 * cellSize + cellSize / 2),
        paint,
      );
    }
  }

  void _drawHintRadar(Canvas canvas) {
    if (!showHintRadar) return;
    final remaining = puzzle.remainingWords;
    if (remaining.isEmpty) return;

    final paint = Paint()
      ..color = AppTheme.warningColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    for (final word in remaining) {
      final start = word.positions.first;
      canvas.drawCircle(
        Offset(start.$2 * cellSize + cellSize / 2, start.$1 * cellSize + cellSize / 2),
        cellSize * 0.3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter oldDelegate) => true;
}
