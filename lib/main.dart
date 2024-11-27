import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:gemai/overlays/dialog.dart';
import 'package:gemai/overlays/gameresult.dart';
import 'package:gemai/overlays/loading.dart';
import 'package:gemai/screens/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlameAudio.bgm.initialize();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  final game = RouterGame();
  runApp(GameWidget(
    game: game,
    overlayBuilderMap: {
      "dialog": (context, RouterGame game) => DialogOverlay(game: game, onTap: (){}),
      "result": (context, RouterGame game) => GameOverlay(game: game, onTap: (){}),
    },
    loadingBuilder: (context) => LoadingOverlay(game: game),
  ));
}
