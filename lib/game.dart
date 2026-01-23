import 'package:flutter/material.dart';
import 'internal_grid.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int? _selectedBlock;
  int? _selectedCell;

  void _selectCell(int blockIndex, int cellIndex) {
    setState(() {
      _selectedBlock = blockIndex;
      _selectedCell = cellIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 2;
    final width = MediaQuery.of(context).size.width;
    final maxSize = height > width ? width : height;
    final boxSize = (maxSize / 3).round().toDouble();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: SizedBox(
          width: boxSize * 3,
          height: boxSize * 3,
          child: GridView.count(
            crossAxisCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(9, (blockIndex) {
              return InternalGridBlock(
                blockIndex: blockIndex,
                boxSize: boxSize,
                selectedBlock: _selectedBlock,
                selectedCell: _selectedCell,
                onCellTap: _selectCell,
              );
            }),
          ),
        ),
      ),
    );
  }
}
