
import 'package:flame/game.dart';
import 'package:sixknight/knapsack/knapsack_components/background_component.dart';

class KnapsackGame extends FlameGame{
  @override
  Future<void> onLoad()async{
    await super.onLoad();
    //adding background to the game
    add(BackgroundComponent());
  }


}