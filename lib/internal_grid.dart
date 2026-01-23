import 'package:flutter/material.dart';

class InternalGridBlock extends StatelessWidget {
  final int blockIndex;
  final double boxSize;
  final int? selectedBlock;
  final int? selectedCell;
  final void Function(int blockIndex, int cellIndex) onCellTap;

  const InternalGridBlock({
    Key? key,
    required this.blockIndex,
    required this.boxSize,
    required this.selectedBlock,
    required this.selectedCell,
    required this.onCellTap,
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
          final isSelected =
              blockIndex == selectedBlock && cellIndex == selectedCell;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.3),
              color: isSelected
                  ? Colors.blueAccent.shade100.withAlpha(100)
                  : Colors.transparent,
            ),
            child: InkWell(
              onTap: () => onCellTap(blockIndex, cellIndex),
              child: const SizedBox.shrink(),
            ),
          );
        }),
      ),
    );
  }
}
