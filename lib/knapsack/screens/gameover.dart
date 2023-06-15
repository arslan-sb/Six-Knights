import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sixknight/knapsack/knapsack_game.dart';

class GameOverMenu extends StatelessWidget {
  static const String ID = 'GameOverMenu';
  final KnapsackGame gameRef;

  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Score: ${gameRef.score}',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  gameRef.reset();
                  gameRef.overlays.remove(GameOverMenu.ID);
                  gameRef.resumeEngine();
                },
                child: Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
