import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sixknight/components/piece.dart';
import 'package:sixknight/components/square.dart';
import 'package:sixknight/helper/helper.dart';
import 'package:sixknight/multiplayer.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

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
  int count=0;

  void _initializeBoard() {
    List<List<Piece?>> newBoard = List.generate(
        4, (index) => List.generate(3, (index) => null));
    for (int i = 0; i < 3; i++) {
      newBoard[0][i] = Piece(
          typed: PieceType.knight,
          isWhite: true,
          imagePath: "lib/images/knight.png"
      );
      newBoard[3][i] = Piece(
          typed: PieceType.knight,
          isWhite: false,
          imagePath: "lib/images/knight.png"
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
    count++;
    setState(() {
      selectedPiece=null;
      selectedRow=-1;
      selectedCol=-1;
      validmoves=[];
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
            content: Text('Congratulations! player has Solved the puzzle in $count moves.'),
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
    } if (terminate) {
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
  // List<List<int>> calculateAllValidMoves(bool isWhite) {
  //   List<List<int>> allValidMoves = [];
  //
  //   // Iterate over the board and calculate valid moves for all pieces
  //   for (int row = 0; row < board.length; row++) {
  //     for (int col = 0; col < board[0].length; col++) {
  //       Piece? piece = board[row][col];
  //       if (piece != null && piece.isWhite == isWhite) {
  //         List<List<int>> pieceValidMoves = calrawvalidmoves(row, col, piece);
  //
  //         // Filter out moves that result in capturing other pieces, including the player's knights
  //         pieceValidMoves = pieceValidMoves.where((move) {
  //           int targetRow = move[0];
  //           int targetCol = move[1];
  //
  //           // Check if the target position is within the board boundaries
  //           if (!isinboard(targetRow, targetCol)) {
  //             return false;
  //           }
  //
  //           Piece? targetPiece = board[targetRow][targetCol];
  //           return targetPiece == null || (targetPiece.isWhite != isWhite && targetPiece.typed != PieceType.knight);
  //         }).toList();
  //
  //         allValidMoves.addAll(pieceValidMoves.map((move) => [row, col] + move));
  //       }
  //     }
  //   }
  //
  //   return allValidMoves;
  // }
  //
  //
  //
  //
  // Future<void> aiMove(bool isWhite) async {
  //   List<List<int>> allValidMoves = calculateAllValidMoves(isWhite);
  //
  //   if (allValidMoves.isNotEmpty) {
  //     // Exclude moves that capture the player's knights
  //     List<List<int>> filteredMoves = allValidMoves.where((move) {
  //       Piece? targetPiece = board[move[2]][move[3]];
  //       return targetPiece == null || (targetPiece.isWhite != isWhite || targetPiece.typed != PieceType.knight);
  //     }).toList();
  //
  //     if (filteredMoves.isEmpty) {
  //       return;  // No valid moves available
  //     }
  //
  //     // Choose a random valid move from the filtered moves
  //     List<int> randomMove = filteredMoves[Random().nextInt(filteredMoves.length)];
  //
  //     // Simulate a delay for the AI move
  //     await Future.delayed(Duration(seconds: 1));
  //
  //     // Make the move
  //     setState(() {
  //       board[randomMove[2]][randomMove[3]] = board[randomMove[0]][randomMove[1]];
  //       board[randomMove[0]][randomMove[1]] = null;
  //     });
  //
  //     checkcomplete();
  //   }
  // }



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
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text('Six Knights'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if(value == 'Single Player'){
                    // Add your logic for single player mode here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameBoard()),
                    );
                  }
                  else if(value == 'Multi Player'){
                    // Add your logic for multi player mode here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MultiPlayer()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Single Player',
                    child: Text('Single Player'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Multi Player',
                    child: Text('Multi Player'),
                  ),
                ],
              ),
            ],
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
          ),


            body: GridView.builder(
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
                  multi: false,
                );
              }),
        )
    );
  }
}