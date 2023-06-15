

import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:math';
import 'package:sixknight/knapsack/constansts/globals.dart';
import 'package:sixknight/knapsack/knapsack_game.dart';

class LaserComponent extends SpriteComponent with
    HasGameRef<KnapsackGame>,CollisionCallbacks{
  final double _spriteHeight=80;
  final Vector2 startPosition;
  final String spritePath;
  late Vector2 _velocity;
  double speed=150;
  double degree= pi/180;


  LaserComponent({required this.startPosition,required this.spritePath});

  @override
  Future<void> onLoad()async{
    await super.onLoad();

    sprite = await gameRef.loadSprite(spritePath);
    position=startPosition;
    width=height=_spriteHeight;
    anchor=Anchor.center;

    double spawnAngle=_getSpawnAngle();
    final double vx =cos(spawnAngle*degree)*speed;
    final double vy =sin(spawnAngle*degree)*speed;

    _velocity=Vector2(vx, vy);

    add(CircleHitbox());

  }

  @override
  void update(dt)
  {
    super.update(dt);
    position+=_velocity * dt;

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      final Vector2 collisionPoint = intersectionPoints.first;

      // Check collision with right side of the screen
      if (collisionPoint.x >= gameRef.size.x - width / 2) {
        position.x = gameRef.size.x - width / 2;
        _velocity.x = -_velocity.x.abs();
      }

      // Check collision with left side of the screen
      if (collisionPoint.x <= width / 2) {
        position.x = width / 2;
        _velocity.x = _velocity.x.abs();
      }

      // Check collision with top side of the screen
      if (collisionPoint.y <= height / 2) {
        position.y = height / 2;
        _velocity.y = _velocity.y.abs();
      }

      // Check collision with bottom side of the screen
      if (collisionPoint.y >= gameRef.size.y - height / 2) {
        position.y = gameRef.size.y - height / 2;
        _velocity.y = -_velocity.y.abs();
      }
    }
  }

  double _getSpawnAngle()
  {
    final random=Random().nextDouble();
    final spawnAngle=lerpDouble(0, 360 , random)!;

    return spawnAngle;

  }

}