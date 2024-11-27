import 'dart:async' as async;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/comgen/textassets.dart';
import 'package:gemai/components/TappableSpriteComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/screens/router.dart';

class Knowledge extends Component with TapCallbacks, HasGameRef<RouterGame>{
  late TappableSpriteComponent nextButton;
  late TappableSpriteComponent prevButton;
  late TextBoxComponent textDesc;
  int position = 0;
  
  @override
  async.FutureOr<void> onLoad () {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    final book = game.book;

    final charaTeacherImage = game.charaTeacherImage;
    SpriteComponent charaTeacher = SpriteComponent.fromImage(charaTeacherImage)
        ..size = Vector2((240 / charaTeacherImage.height) * charaTeacherImage.width, 240)
        ..position = Vector2(20, screenHeight + 5)
        ..anchor = Anchor.bottomLeft;
        
    final nextButtonImage = game.nextButtonImage;
    nextButton = TappableSpriteComponent(sprite: Sprite(nextButtonImage), onPressed: () {
      if (position + 1 < (TextAssets.dKnowledge[book]?.length ?? 0)){
        position++;
      }else{
        position = 0;
        game.router.pushReplacement(game.nextGame);
        return;
      }

      textDesc.text = TextAssets.dKnowledge[book]?[position]["label"] as String;
      textDesc.align = TextAssets.dKnowledge[book]?[position]["align"] as Anchor;
      prevButton.opacity = 1;
    },)
            ..position = Vector2(screenWidth - 130, 310)
            ..size = Vector2(100, nextButtonImage.height * (100/nextButtonImage.width))
            ..anchor = Anchor.center;

    final prevButtonImage = game.prevButtonImage;
    prevButton = TappableSpriteComponent(sprite: Sprite(prevButtonImage), onPressed: () {
      if (position - 1 == 0){
        prevButton.opacity = 0;
      }
      
      if (position - 1 >= 0){
        position--;
      }else{
        return;
      }
      
      textDesc.text = TextAssets.dKnowledge[book]?[position]["label"] as String;
      textDesc.align = TextAssets.dKnowledge[book]?[position]["align"] as Anchor;
    },)
            ..position = Vector2(screenWidth - 260, 310)
            ..size = Vector2(100, prevButtonImage.height * (100/prevButtonImage.width))
            ..anchor = Anchor.center
            ..opacity = 0;
    
    TextBoxComponent textTitle = TextBoxComponent(
      text: book,
      textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 20, color: Color(0xFFCFAF8B))),
      anchor: Anchor.center,
      size: Vector2(400, 380),
      position: Vector2(screenWidth/2 + 96, 265),
      align: Anchor.topCenter
    );

    textDesc = TextBoxComponent(
      text:  TextAssets.dKnowledge[book]?[position]["label"].toString(),
      textRenderer: TextPaint(style: const TextStyle(height: 1.2, letterSpacing: -1.0, fontFamily: Assets.fontPrimary, fontSize: 14, color: Color(0xFFCFAF8B))),
      anchor: Anchor.center,
      size: Vector2(400, 380),
      position: Vector2(screenWidth/2 + 96, 290),
      align: TextAssets.dKnowledge[book]?[position]["align"] as Anchor
    );

    addAll([
      Background(assetPath: Assets.background2),
      charaTeacher,
      nextButton,
      prevButton,
      textTitle,
      textDesc
    ]);

    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    if(nextButton.containsPoint(event.devicePosition)){
      nextButton.onTapDown();
    }
    if(prevButton.containsPoint(event.devicePosition)){
      prevButton.onTapDown();
    }
    super.onTapDown(event);
  }
  
  @override
  void onTapUp(TapUpEvent event) {
    if(nextButton.containsPoint(event.devicePosition)){
      nextButton.onTapUp();
      FlameAudio.play(Assets.fxClick);
    }
    if(prevButton.containsPoint(event.devicePosition)){
      prevButton.onTapUp();
      FlameAudio.play(Assets.fxClick);
    }
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    nextButton.onTapCancel();
    prevButton.onTapCancel();
    return super.onTapCancel(event);
  }
}