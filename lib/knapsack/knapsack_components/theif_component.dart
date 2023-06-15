import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:sixknight/knapsack/constansts/globals.dart';
import 'package:sixknight/knapsack/knapsack_components/laser.dart';
import 'package:sixknight/knapsack/knapsack_game.dart';

enum MovementState{
  idle,
  slideLeft,
  slideRight,
  frozen
}
class TheifComponent extends SpriteComponent
    with HasGameRef<KnapsackGame>,CollisionCallbacks{
  final double _spriteHeight=90;
  final double _speed=500;

  late double _rightbound;
  late double _leftbound;
  late double _upbound;
  late double _downbound;

  JoystickComponent joystick;

  // Define your map variable
  Map<MovementState, Sprite> sprites = {};
  final Timer _timer =Timer(4);
  // Add a variable for the current state
  MovementState currentState = MovementState.idle;
  bool _frozen = false;


  TheifComponent({required this.joystick});
  @override
  Future<void> onLoad()async{
    await super.onLoad();

    // Load sprites
    sprites[MovementState.idle] = await gameRef.loadSprite(Globals.theifIdleSprite);
    sprites[MovementState.slideLeft] = await gameRef.loadSprite(Globals.theifLeftSprite);
    sprites[MovementState.slideRight] = await gameRef.loadSprite(Globals.theifRightSprite);
    sprites[MovementState.frozen] = await gameRef.loadSprite(Globals.theifFrozenSprite);


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
    add(CircleHitbox());
  }

  @override
  void update(dt){
    super.update(dt);
    if(!_frozen){
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
    else{
      _timer.update(dt);
      if(_frozen){
        if(_timer.finished)
        {
          _unfreezeThief();
        }
      }

    }

  }
  void _unfreezeThief()
  {
    if(_frozen){
      _frozen=false;
      changeState(MovementState.idle);
    }

  }

  void _freezeThief(){
    if(!_frozen){
      //FlameAudio.play(Globals.thiefFrozenSound);
      _frozen=true;
      changeState(MovementState.frozen);
    }
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints,PositionComponent other)
  {
    super.onCollision(intersectionPoints, other);
    if(!_frozen){
      if(other is LaserComponent)
      {
        //FlameAudio.play(Globals.thiefKillSound);
        if(!_frozen){
          _freezeThief();
        }

      }
    }

  }
  // Whenever you change state, update the sprite:
  void changeState(MovementState newState) {
    currentState = newState;
    sprite = sprites[newState];
  }
}