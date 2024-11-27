import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:gemai/comgen/textassets.dart';
import 'package:gemai/components/TappableComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/screens/chara_pick.dart';
import 'package:gemai/screens/router.dart';

class Board extends Component with TapCallbacks, HasGameReference<RouterGame>{
  late TappableComponent button;

  @override
  FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;


    final charaTeacherImage = game.charaTeacherImage;
    SpriteComponent charaTeacher = SpriteComponent.fromImage(charaTeacherImage)
        ..size = Vector2((230 / charaTeacherImage.height) * charaTeacherImage.width, 230)
        ..position = Vector2(20, screenHeight)
        ..anchor = Anchor.bottomLeft;

    TextBoxComponent textBoard = TextBoxComponent(
      text: TextAssets.dOpening,
      textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 18, color: Color(0xFFCFAF8B))),
      anchor: Anchor.center,
      size: Vector2(440, 200),
      position: Vector2(screenWidth/2, 165),
      align: Anchor.topCenter
    );

    final goImage = game.boardImage;
    SpriteComponent go = SpriteComponent.fromImage(goImage)
        ..size = Vector2(goImage.width * (50 / goImage.height), 50);

    TextBoxComponent textGo = TextBoxComponent(
      text: "Let's Go!",
      textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 21, color: Color(0xFFCFAF8B))),
      size: go.size,
      align: Anchor.topCenter
    );

    button = TappableComponent(component: PositionComponent(children: [go, textGo], position: Vector2(screenWidth/2, 250), size: go.size, anchor: Anchor.center)
      ,onPressed: () {
        game.router.pushReplacement(Route(CharaPick.new));
      }
    );

    addAll([
      Background(assetPath: Assets.background4),
      textBoard,
      charaTeacher,
      button
    ]);
    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    if(button.containsPoint(event.devicePosition)){
      button.onTapDown();
    }
    super.onTapDown(event);
  }
  
  @override
  void onTapUp(TapUpEvent event) {
    if(button.containsPoint(event.devicePosition)){
      button.onTapUp();
      FlameAudio.play(Assets.fxClick);
    }
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    button.onTapCancel();
    return super.onTapCancel(event);
  }
}