import 'package:flutter/material.dart';
import 'package:sixknight/components/piece.dart';
import 'package:sixknight/components/square.dart';
import 'package:sixknight/values/colors.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //Piece of board
  Piece knighte= Piece(
      typed: PieceType.knight,
      isWhite: false,
      imagePath: "lib/images/k.png"
  );

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: background,
      body: GridView.builder(
          itemCount: 3*4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context,index) {
          bool isWhite=(index)%2==0;
          return Square(
              isWhite: isWhite,
            piece: knighte,
          );
          }),
    );
  }
}
