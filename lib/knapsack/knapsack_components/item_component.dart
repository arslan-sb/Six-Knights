import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:sixknight/knapsack/constansts/globals.dart';
import 'package:sixknight/knapsack/knapsack_components/theif_component.dart';
import 'package:sixknight/knapsack/knapsack_game.dart';

class ItemComponent extends SpriteComponent with HasGameRef<KnapsackGame>,CollisionCallbacks{
  final String spritePath;
  final double _spriteHeight=80;
  final Random _random=Random();
  final int weight;
  final int profit;
  ItemComponent(this.spritePath,this.weight,this.profit);

  @override
  Future<void> onLoad()async{
    await super.onLoad();
    sprite = await gameRef.loadSprite(spritePath);
    size=gameRef.size;
    height=width=_spriteHeight;
    position=_getRandomPosition();
    anchor=Anchor.center;
    add(CircleHitbox());
    gameRef.my2DList.add([weight,profit]);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints,PositionComponent other)
  {
    super.onCollision(intersectionPoints, other);
    if(other is TheifComponent)
      {
        FlameAudio.play(Globals.itemGrabSound);
        removeFromParent();
        gameRef.score+=profit;
        gameRef.max_weight-=weight;
        gameRef.add(createRandomItem());
      }
  }

  Vector2 _getRandomPosition(){
    double x=_random.nextInt(gameRef.size.x.toInt()).toDouble();
    double y=_random.nextInt(gameRef.size.y.toInt()).toDouble();

    return Vector2(x, y);
  }
}
