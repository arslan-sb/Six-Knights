enum PieceType{knight}

class Piece{
  final PieceType typed;
  final bool isWhite;
  final String imagePath;
  Piece({required this.typed,required this.isWhite, required this.imagePath});

}