import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InternalGridBlock extends StatelessWidget {
  final int blockIndex;
  final double boxSize;
  final int? selectedBlock;
  final int? selectedCell;
  final void Function(int blockIndex, int cellIndex) onCellTap;
  final Puzzle puzzle;

  const InternalGridBlock({
    Key? key,
    required this.blockIndex,
    required this.boxSize,
    required this.selectedBlock,
    required this.selectedCell,
    required this.onCellTap,
    required this.puzzle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: List.generate(9, (cellIndex) {
          // Conversion bloc/cell → row/col
          final row = (blockIndex ~/ 3) * 3 + (cellIndex ~/ 3);
          final col = (blockIndex % 3) * 3 + (cellIndex % 3);

          // Valeur actuelle dans la grille
          final value =
              puzzle.board()?.matrix()?[row][col].getValue() ?? 0;

          // Valeur attendue pour cette cellule
          final expected =
              puzzle.solvedBoard()?.matrix()?[row][col].getValue() ?? 0;

          final isSelected =
              blockIndex == selectedBlock && cellIndex == selectedCell;

          // Affichage : si valeur vide → afficher valeur attendue en gris clair
          final displayValue = value == 0 ? expected : value;
          final isExpected = value == 0 && expected != 0;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.3),
              color: isSelected
                  ? Colors.blueAccent.shade100.withAlpha(100)
                  : Colors.transparent,
            ),
            child: InkWell(
              onTap: () => onCellTap(blockIndex, cellIndex),
              child: Center(
                child: Text(
                  displayValue == 0 ? '' : displayValue.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: isExpected ? Colors.black12 : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
