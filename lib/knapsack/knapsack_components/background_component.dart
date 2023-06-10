

import 'package:flame/components.dart';
import 'package:sixknight/knapsack/constansts/globals.dart';
import 'package:sixknight/knapsack/knapsack_game.dart';

class BackgroundComponent extends SpriteComponent with HasGameRef<KnapsackGame>{
  @override
  Future<void> onLoad()async{
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size=gameRef.size;
  }
}