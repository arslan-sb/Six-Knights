
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sixknight/knapsack/constansts/globals.dart';
import 'package:sixknight/knapsack/knapsack_components/background_component.dart';
import 'package:sixknight/knapsack/knapsack_components/item_component.dart';
import 'package:sixknight/knapsack/knapsack_components/laser.dart';
import 'package:sixknight/knapsack/screens/gameover.dart';

import 'inputs/joystick.dart';
import 'knapsack_components/theif_component.dart';

class KnapsackGame extends FlameGame with DragCallbacks, HasCollisionDetection{
  int score=0;
  int max_weight=100;
  late Timer _timer;
  int _remainingTime=50;

  late TextComponent _weightText;

  late TextComponent _scoreText;

  late TextComponent _timeText;

  List<List<int>> my2DList = create2DList(0,0);



  @override
  Future<void> onLoad()async{
    await super.onLoad();
    //adding background to the game
    add(BackgroundComponent());
    // Register the GameOverMenu overlay.
   // overlays.register(GameOverMenu.ID, (context, gameRef) => GameOverMenu(gameRef: gameRef));
    max_weight=generateRandomNumber(50, 200);
    // Make sure joystick does not have a parent before adding it
    // Add joystick only if it's not part of the game already
    // Remove the joystick from its parent before adding it
    // Create a new joystick and add it

    JoystickComponent joystick = createJoystick();
    _timer=Timer(1,repeat: true,
        onTick: (){
          if(_remainingTime==0 || max_weight<=0){
            pauseEngine();
            overlays.add(GameOverMenu.ID);
           // addOverlay(GameOverMenu(gameRef: this));
          }
          else{
            _remainingTime-=1;
          }
        });
    _timer.start();
    add(ScreenHitbox());
    add(createRandomItem());
    add(createRandomItem());
    add(createRandomItem());
    // add(ItemComponent(Globals.treasuryBoxSprite,generateRandomNumber(5, 10),generateRandomNumber(5, 11)));
    // add(ItemComponent(Globals.goldSprite,generateRandomNumber(1, 5),generateRandomNumber(1, 6)));
    // add(ItemComponent(Globals.itemDhaFileSprite,generateRandomNumber(4, 10),generateRandomNumber(6, 12)));
    add(LaserComponent(spritePath: Globals.laserVerSprite,startPosition: Vector2(size.x-100,size.y-100)));
    add(LaserComponent(spritePath: Globals.laserSprite,startPosition: Vector2(125,125)));
    add(TheifComponent(joystick: joystick));
    add(joystick);
    _scoreText=TextComponent(text: 'Score: $score',
        position: Vector2(20,40),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
            style: TextStyle(color: BasicPalette.white.color,fontSize: 24))
    );
    _weightText=TextComponent(text: 'Capacity: $max_weight',
        position: Vector2(size.x/2,40),
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
            style: TextStyle(color: BasicPalette.white.color,fontSize: 24))
    );

    _timeText=TextComponent(text: 'Time: $_remainingTime seconds',
      position: Vector2(size.x-20,40),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
          style: TextStyle(color: BasicPalette.white.color,fontSize: 24))
    );
    add(_scoreText);
    add(_timeText);
    add(_weightText);



  }

  @override
  void update(dt){
    super.update(dt);
    _timer.update(dt);
    _scoreText.text='Score: ${score}';
    _timeText.text='Time: $_remainingTime';
    if(max_weight<0){
      _weightText.text='Capacity: 0';
    }
    else{
      _weightText.text='Capacity: ${max_weight}';
    }

  }
  void reset()
  {
    score=0;
    _remainingTime=generateRandomNumber(20, 50);
    max_weight=generateRandomNumber(50, 200);
  }


}