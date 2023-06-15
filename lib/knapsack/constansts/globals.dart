import 'dart:math';

import '../knapsack_components/item_component.dart';

class Globals{
  Globals._();

  static const String backgroundSprite="abc.jpeg";
  static const String theifIdleSprite="stillknap.png";
  static const String theifRightSprite="rightknap.png";
  static const String theifLeftSprite="leftknap.png";
  static const String theifFrozenSprite="fall.png";
  static const String treasurySprite="treasury.png";
  static const String goldSprite="gold.png";
  static const String treasuryBoxSprite="treasuryBox.png";
  static const String itemGrabSound="grab.wav";
  static const String thiefFrozenSound="freeze.wav";
  static const String itemDhaFileSprite="dhafile.png";
  static const String laserSprite="lasers.png";
  static const String laserVerSprite="laserv.png";
  static const String backgroundhome="peakpx.jpg";
}

final Random _random = Random();

int generateRandomNumber(int min, int max) {
  // Add 1 to the max value to make it inclusive
  int range = max - min + 1;

  // Generate a random number within the range
  int randomNumber = _random.nextInt(range);

  // Add the minimum value to shift the range
  int result = randomNumber + min;

  return result;
}


List<List<int>> create2DList(int rows, int columns) {
  List<List<int>> twoDList = List<List<int>>.generate(
    rows,
        (row) => List<int>.filled(columns, 0),
  );

  return twoDList;
}


ItemComponent createRandomItem() {
  int randomNumber = generateRandomNumber(1, 3);
  String spritePath;
  int randomWeight;
  int randomProfit;
  if (randomNumber == 1) {
    spritePath = Globals.goldSprite;
    randomWeight = generateRandomNumber(1, 5);
    randomProfit = generateRandomNumber(1, 6);
  } else if (randomNumber == 2) {
    spritePath = Globals.treasuryBoxSprite;
    randomWeight = generateRandomNumber(5, 10);
    randomProfit = generateRandomNumber(6, 12);
  } else {
    spritePath = Globals.itemDhaFileSprite;
    randomWeight = generateRandomNumber(4, 10);
    randomProfit = generateRandomNumber(7, 13);
  }



  return ItemComponent(spritePath, randomWeight, randomProfit);
}