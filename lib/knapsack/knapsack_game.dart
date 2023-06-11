
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:sixknight/knapsack/knapsack_components/background_component.dart';

import 'inputs/joystick.dart';
import 'knapsack_components/theif_component.dart';

class KnapsackGame extends FlameGame with DragCallbacks{
  @override
  Future<void> onLoad()async{
    await super.onLoad();
    //adding background to the game
    add(BackgroundComponent());


    // Make sure joystick does not have a parent before adding it
    // Add joystick only if it's not part of the game already
    // Remove the joystick from its parent before adding it
    // Create a new joystick and add it

    JoystickComponent joystick = createJoystick();
    add(joystick);

    add(TheifComponent(joystick: joystick));
  }


}