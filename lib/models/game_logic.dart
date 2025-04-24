import 'dart:math';

class GameLogic {
  List<String> board = List.filled(9, '');

  String currentPlayer = 'X';

  void makeMove(int index) {
    if (board[index] == '') {
      board[index] = currentPlayer;
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
  }

  void resetGame() {
    board = List.filled(9, '');
    currentPlayer = 'X';
  }

  String? checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != '' &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        return board[pattern[0]];
      }
    }

    if (!board.contains('')) {
      return 'Draw';
    }

    return null;
  }

  int? getPCMove() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    String pc = currentPlayer;
    String opponent = pc == 'X' ? 'O' : 'X';

    
    for (var pattern in winPatterns) {
      int pcCount = 0;
      int emptyIndex = -1;

      for (var index in pattern) {
        if (board[index] == pc) {
          pcCount++;
        } else if (board[index] == '') {
          emptyIndex = index;
        }
      }

      if (pcCount == 2 && emptyIndex != -1) {
        return emptyIndex; 
      }
    }

    
    for (var pattern in winPatterns) {
      int opponentCount = 0;
      int emptyIndex = -1;

      for (var index in pattern) {
        if (board[index] == opponent) {
          opponentCount++;
        } else if (board[index] == '') {
          emptyIndex = index;
        }
      }

      if (opponentCount == 2 && emptyIndex != -1) {
        return emptyIndex; 
      }
    }

    
    final emptyCells =
        board
            .asMap()
            .entries
            .where((entry) => entry.value == '')
            .map((entry) => entry.key)
            .toList();

    if (emptyCells.isNotEmpty) {
      final random = Random();
      return emptyCells[random.nextInt(emptyCells.length)];
    }

    return null; 
  }
}
