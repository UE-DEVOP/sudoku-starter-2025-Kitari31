import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'internal_grid.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Puzzle? _puzzle; // Le puzzle généré
  bool _isLoading = true; // Indique si la génération est en cours
  int? _selectedBlock;
  int? _selectedCell;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  Future<void> _generatePuzzle() async {
    final puzzle = Puzzle(PuzzleOptions(name: 'Sudoku', clues: 30));
    await puzzle.generate();
    if (!mounted) return;
    setState(() {
      _puzzle = puzzle;
      _isLoading = false;
    });
  }

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
        child: _isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
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
                      puzzle: _puzzle!,
                    );
                  }),
                ),
              ),
      ),
    );
  }
}
