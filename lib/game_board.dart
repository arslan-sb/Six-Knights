import 'package:flutter/material.dart';
import 'package:sixknight/components/piece.dart';
import 'package:sixknight/components/square.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //Piece of board
  Piece knights= Piece(
      typed: PieceType.knight,
      isWhite: true,
      imagePath: "lib/images/k.png"
  );

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GridView.builder(
          itemCount: 3*4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context,index) {
          bool isWhite=(index)%2==0;
          return Square(
              isWhite: isWhite,
            piece: knights,
          );
          }),
    );
  }
}
