import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sixknight/components/piece.dart';
import 'package:sixknight/components/square.dart';
import 'package:sixknight/helper/helper.dart';

class MultiPlayer extends StatefulWidget {
  const MultiPlayer({super.key});

  @override
  State<MultiPlayer> createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayer> {

  Piece? selectedPiece;
  int selectedRow=-1;
  int selectedCol=-1;
  List<List<int>> validmoves=[];

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

//board using 2d list
  late List<List<Piece?>> board;
  bool isWhitesTurn = true;
  int count=0;

  void _initializeBoard() {
    List<List<Piece?>> newBoard = List.generate(
        4, (index) => List.generate(3, (index) => null));
    for (int i = 0; i < 3; i++) {
      newBoard[0][i] = Piece(
          typed: PieceType.knight,
          isWhite: true,
          imagePath: "lib/images/k.png"
      );
      newBoard[3][i] = Piece(
          typed: PieceType.knight,
          isWhite: false,
          imagePath: "lib/images/k.png"
      );
    }
    board = newBoard;
  }


  void selectedpiece(int row,int col){
    setState(() {
      if(board[row][col]!=null)
      {
        selectedPiece=board[row][col];
        selectedRow=row;
        selectedCol=col;
        validmoves=calrawvalidmoves(selectedRow,selectedCol,selectedPiece);
      }
      else if(selectedPiece !=null && validmoves.any((element)=>element[0]== row && element[1] == col))
      {
        movepiece(row, col);
      }
      aiMove();
    });
  }
  List<List<int>> calrawvalidmoves(int row,int col, Piece? selp) {
    List<List<int>> candmoves = [];
    if (selp == null) {
      return [];
    }
    int direction = selp!.isWhite ? -1: 1;

    var knightmoves = [
      [-2,-1],
      [-2,1],
      [-1,-2],
      [-1,2],
      [1,-2],
      [1,2],
      [2,-1],
      [2,1],
    ];
    for (var move in knightmoves) {
      var newRow = row + move[0];
      var newCol = col + move[1];
      if (!isinboard(newRow, newCol) || board[newRow][newCol] != null) {
        continue;
      }
      candmoves.add([newRow, newCol]);
    }
    return candmoves;
  }


  void movepiece(int newrow, int newcol){
    board[newrow][newcol]=selectedPiece;
    board[selectedRow][selectedCol]=null;
    setState(() {
      selectedPiece=null;
      selectedRow=-1;
      selectedCol=-1;
      validmoves=[];
      count++;
    });
    checkcomplete();
  }

  void checkcomplete() {
    bool isComplete = false;
    bool isWhiteWinner = false;
    bool terminate=false;

    // Check if all the top row pieces are white knights
    bool allWhiteKnightsReachedBottom = true;
    for (int i = 0; i < 3; i++) {
      Piece? piece = board[0][i];
      if (piece == null || piece.isWhite || piece.typed != PieceType.knight) {
        allWhiteKnightsReachedBottom = false;
        break;
      }
    }
    // Check if all the bottom row pieces are black knights
    bool allBlackKnightsReachedTop = true;
    for (int i = 0; i < 3; i++) {
      Piece? piece = board[3][i];
      if (piece == null || !piece.isWhite || piece.typed != PieceType.knight) {
        allBlackKnightsReachedTop = false;
        break;
      }
    }

    // Check if any condition is met for game completion
    if (allWhiteKnightsReachedBottom && allBlackKnightsReachedTop) {
      isComplete = true;
      //isWhiteWinner = true;
      // } else if (allBlackKnightsReachedTop) {
      //   isComplete = true;
      //   isWhiteWinner = false;
    }
    if(count>=100)
    {
      terminate=true;
    }
    // Show dialog if game is complete
    if (isComplete) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String winnerText = isWhiteWinner ? "Black" : "White";
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Congratulations! $winnerText player has won the game.'),
            actions: [
              TextButton(
                child: Text('Quit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    }
    if (terminate) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String winnerText = isWhiteWinner ? "Black" : "White";
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('TOO MANY MOVES'),
            actions: [
              TextButton(
                child: Text('Quit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    }
  }


  void resetGame()
  {
    Navigator.pop(context);
    _initializeBoard();
    setState(() {});
  }

  // scoring function that returns the number of valid moves for the AI player
  int score(List<List<Piece?>> Board) {
    int score = 0;
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[0].length; col++) {
        Piece? piece = board[row][col];
        if (piece != null && piece.isWhite && piece.typed == PieceType.knight) {
          score += calrawvalidmoves(row, col, piece).length;
        }
      }
    }
    return score;
  }

// minimax function that chooses the best move for the AI player
  List<int> minimax( List<List<Piece?>> board, int depth, bool maximizingPlayer) {
    if (depth == 0) {
      return [score(board), -1, -1, -1, -1];  // return [score, oldRow, oldCol, newRow, newCol]
    }

    if (maximizingPlayer) {
      int maxScore = -1;
      List<int> maxMove = [-1, -1, -1, -1];

      for (int row = 0; row < board.length; row++) {
        for (int col = 0; col < board[0].length; col++) {
          Piece? piece = board[row][col];
          if (piece != null && piece.isWhite && piece.typed == PieceType.knight) {
            List<List<int>> validMoves = calrawvalidmoves(row, col, piece);
            for (List<int> move in validMoves) {
              late List<List<Piece?>> newBoard = board;  // clone the board to avoid modifying the original
              newBoard[move[0]][move[1]] = newBoard[row][col];
              newBoard[row][col] = null;
              List<int> result = minimax(newBoard, depth - 1, false);
              if (result[0] > maxScore) {
                maxScore = result[0];
                maxMove = [row, col] + move;
              }
            }
          }
        }
      }

      return [maxScore] + maxMove;
    } else {
      int minScore = 9999;
      List<int> minMove = [-1, -1, -1, -1];

      for (int row = 0; row < board.length; row++) {
        for (int col = 0; col < board[0].length; col++) {
          Piece? piece = board[row][col];
          if (piece != null && !piece.isWhite && piece.typed == PieceType.knight) {
            List<List<int>> validMoves = calrawvalidmoves(row, col, piece);
            for (List<int> move in validMoves) {
              late List<List<Piece?>> newBoard = board;  // clone the board to avoid modifying the original
              newBoard[move[0]][move[1]] = newBoard[row][col];
              newBoard[row][col] = null;
              List<int> result = minimax(newBoard, depth - 1, true);
              if (result[0] < minScore) {
                minScore = result[0];
                minMove = [row, col] + move;
              }
            }
          }
        }
      }

      return [minScore] + minMove;
    }
  }
  Future<void> aiMove() async {
    List<int> bestMove = minimax(board, 2, true);  // 2 is the depth of the search tree
    if (bestMove[1] == -1) return;  // no valid move found

    // Make the move
    setState(() {
      board[bestMove[3]][bestMove[4]] = board[bestMove[1]][bestMove[2]];
      board[bestMove[1]][bestMove[2]] = null;
    });

    checkcomplete();
  }


// class _GameBoardState extends State<GameBoard> {
//   //Piece of board
//   Piece knights = Piece(
//       typed: PieceType.knight,
//       isWhite: true,
//       imagePath: "lib/images/k.png"
//   );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(title: Text('Six Knights'),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
          ),
          body: Column(
            children: [
              GridView.builder(
                  itemCount: 3 * 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    bool isWhite = (index) % 2 == 0;
                    bool isSelect = selectedRow == row && selectedCol == col;
                    bool isvalidmove=false;
                    for(var position in validmoves)
                    {
                      if(position[0]==row && position[1]==col)
                      {
                        isvalidmove=true;
                      }
                    }
                    return Square(
                      isWhite: isWhite,
                      piece: board[row][col],
                      isSelected: isSelect,
                      isvalid: isvalidmove,
                      onTap:() => selectedpiece(row,col),
                      multi: true,
                    );
                  }),
            ],
          ),
        )
    );
  }
}