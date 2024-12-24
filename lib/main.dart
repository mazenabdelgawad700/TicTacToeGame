import 'package:flutter/material.dart';

void main() => runApp(const TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  bool isPlayerTurn = true;
  bool gameOver = false;
  String winner = '';

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayerTurn = true;
      gameOver = false;
      winner = '';
    });
  }

  bool checkWinner(String player) {
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == player &&
          board[i + 1] == player &&
          board[i + 2] == player) {
        return true;
      }
    }

    for (int i = 0; i < 3; i++) {
      if (board[i] == player &&
          board[i + 3] == player &&
          board[i + 6] == player) {
        return true;
      }
    }

    if (board[0] == player && board[4] == player && board[8] == player) {
      return true;
    }
    if (board[2] == player && board[4] == player && board[6] == player) {
      return true;
    }

    return false;
  }

  bool isBoardFull() {
    return !board.contains('');
  }

  void aiMove() {
    int moveIndex = findWinningMove('O');
    if (moveIndex != -1) {
      makeMove(moveIndex);
      return;
    }

    moveIndex = findWinningMove('X');
    if (moveIndex != -1) {
      makeMove(moveIndex);
      return;
    }

    if (board[4] == '') {
      makeMove(4);
      return;
    }

    List<int> corners = [0, 2, 6, 8];
    corners.shuffle();
    for (int corner in corners) {
      if (board[corner] == '') {
        makeMove(corner);
        return;
      }
    }

    List<int> sides = [1, 3, 5, 7];
    sides.shuffle();
    for (int side in sides) {
      if (board[side] == '') {
        makeMove(side);
        return;
      }
    }
  }

  int findWinningMove(String player) {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = player;
        if (checkWinner(player)) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }
    return -1;
  }

  void makeMove(int index) {
    setState(() {
      board[index] = 'O';
      isPlayerTurn = true;

      if (checkWinner('O')) {
        gameOver = true;
        winner = 'AI';
      } else if (isBoardFull()) {
        gameOver = true;
        winner = 'Draw';
      }
    });
  }

  void onTilePressed(int index) {
    if (!isPlayerTurn || board[index] != '' || gameOver) return;

    setState(() {
      board[index] = 'X';

      if (checkWinner('X')) {
        gameOver = true;
        winner = 'Player';
      } else if (isBoardFull()) {
        gameOver = true;
        winner = 'Draw';
      } else {
        isPlayerTurn = false;
        Future.delayed(const Duration(milliseconds: 500), aiMove);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (gameOver)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                winner == 'Draw' ? "It's a Draw!" : '$winner Wins!',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onTilePressed(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      board[index],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: resetGame,
            child: const Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}
