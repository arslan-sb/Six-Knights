import 'package:flutter/material.dart';
import 'package:sixknight/components/piece.dart';
import 'package:sixknight/values/colors.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final Piece? piece;
  const Square({
    super.key,
    required this.isWhite,
    required this.piece
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite? foreground:background,
      child: piece!=null?Image.asset(
        piece!.imagePath,
        color: piece!.isWhite?Colors.white:Colors.black,)
          :null,
    );
  }
}