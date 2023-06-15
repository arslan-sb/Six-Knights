
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sixknight/knapsack/constansts/globals.dart';

import 'game_board.dart';
import 'knapsack/knapsack_game.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Select a Game'),
      ),


      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/peakpx.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              ElevatedButton(

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const GameBoard()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set the desired background color
                ),
                child: Text('Play Six Knight'),

              ),
              ElevatedButton(
                onPressed: () {
                  // Replace with your actual second game screen
                  Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => GameWidget(game: KnapsackGame())),
                  );
                },
                child: Text('Play Knapsack'),
              ),
            ],
          ),
        ),
      ),
    );

  }
}