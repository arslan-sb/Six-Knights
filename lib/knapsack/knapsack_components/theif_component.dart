

import 'package:flame/components.dart';
import 'package:sixknight/knapsack/constansts/globals.dart';
import 'package:sixknight/knapsack/knapsack_game.dart';

enum MovementState{
  idle,
  slideLeft,
  slideRight,
}
class TheifComponent extends SpriteComponent with HasGameRef<KnapsackGame>{
  final double _spriteHeight=100;
  final double _speed=500;

  late double _rightbound;
  late double _leftbound;
  late double _upbound;
  late double _downbound;

  JoystickComponent joystick;

  // Define your map variable
  Map<MovementState, Sprite> sprites = {};

  // Add a variable for the current state
  MovementState currentState = MovementState.idle;

  TheifComponent({required this.joystick});
  @override
  Future<void> onLoad()async{
    await super.onLoad();

    // Load sprites
    sprites[MovementState.idle] = await gameRef.loadSprite(Globals.theifIdleSprite);
    sprites[MovementState.slideLeft] = await gameRef.loadSprite(Globals.theifLeftSprite);
    sprites[MovementState.slideRight] = await gameRef.loadSprite(Globals.theifRightSprite);


    // Set the initial sprite
    sprite = sprites[currentState];

    _rightbound=gameRef.size.x-45;
    _leftbound=45;
    _upbound=55;
    _downbound=gameRef.size.y-85;




    position=gameRef.size/2;
    height =_spriteHeight;
    width=_spriteHeight*1.1;
    anchor =Anchor.center;
  }

  @override
  void update(dt){
    super.update(dt);
    if(joystick.direction==JoystickDirection.idle){
      changeState(MovementState.idle);
      return;
    }

    if(x>=_rightbound){
      x=_rightbound-1;
    }

    if(x<=_leftbound){
      x=_leftbound+1;
    }

    if(y>=_downbound){
      y=_downbound-1;
    }
    if(y<=_upbound){
      y=_upbound+1;
    }
    bool movingLeft=joystick.relativeDelta[0]<0;

    if(movingLeft){
      changeState(MovementState.slideLeft);
    }
    else{
      changeState(MovementState.slideRight);
    }
    
    position.add(joystick.relativeDelta*_speed*dt);

  }
  // Whenever you change state, update the sprite:
  void changeState(MovementState newState) {
    currentState = newState;
    sprite = sprites[newState];
  }
}