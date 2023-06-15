import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:sixknight/homescreen.dart';
import 'game_board.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  //await FlameAudio().initialize();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
