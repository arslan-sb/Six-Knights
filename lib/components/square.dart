import 'package:flutter/material.dart';
import 'package:sixknight/components/piece.dart';
import 'package:sixknight/values/colors.dart';
import 'package:sixknight/multiplayer.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final Piece? piece;
  final bool isSelected;
  final bool isvalid;
  final bool multi;
  final void Function()? onTap;
  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.isvalid,
    required this.onTap,
    required this.multi,
  });

  @override
  Widget build(BuildContext context) {
    Color? squarecolor;
    if(isSelected)
    {
      squarecolor=Colors.amber;
    }
    else if(isvalid)
    {
      squarecolor=Colors.amberAccent;
    }
    else {
      squarecolor = isWhite ? foreground : background;
    }
    if(multi==true){
      return Container(
        color: squarecolor,
        child: piece!=null?Image.asset(
          piece!.imagePath,
          color: piece!.isWhite?Colors.white:Colors.black,)
            :null,
      );
    }
    else{
      return GestureDetector(
        onTap: onTap,
        child: Container(
          color: squarecolor,
          child: piece!=null?Image.asset(
            piece!.imagePath,
            color: piece!.isWhite?Colors.white:Colors.black,)
              :null,
        ),
      );
    }

  }
}