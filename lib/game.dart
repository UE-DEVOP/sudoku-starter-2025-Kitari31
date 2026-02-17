import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'internal_grid_block.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Puzzle? _puzzle;
  bool _isLoading = true;
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

  void _enterValue(int value) {
    if (_puzzle == null || _selectedBlock == null || _selectedCell == null) {
      return;
    }

    // Conversion bloc/cell → row/col pour sudoku_api
    final row = (_selectedBlock! ~/ 3) * 3 + (_selectedCell! ~/ 3);
    final col = (_selectedBlock! % 3) * 3 + (_selectedCell! % 3);
    final pos = Position(row: row, column: col);

    setState(() {
      _puzzle!.board()!.cellAt(pos).setValue(value);
    });
  }

  Widget _buildNumberRow(List<int> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values.map((value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            onPressed: () => _enterValue(value),
            child: Text(value.toString()),
          ),
        );
      }).toList(),
    );
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
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
                  const SizedBox(height: 16),
                  _buildNumberRow([1, 2, 3, 4, 5]),
                  const SizedBox(height: 8),
                  _buildNumberRow([6, 7, 8, 9]),
                ],
              ),
      ),
    );
  }
}
