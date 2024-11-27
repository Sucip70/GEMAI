import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:gemai/comgen/textassets.dart';
import 'package:gemai/components/TappableComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/screens/router.dart';

class Question extends Component with TapCallbacks, HasGameReference<RouterGame>{
  late List<TappableComponent> optionButton;
  late TextComponent poin;
  late TextBoxComponent textQuestion;
  double g = 100;
  double speed = 0;
  bool isBlockEvent = false;

  int position = 2;

  @override
  FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    const boardWidth = 440.0;
    String kitab = game.book;
    if (kitab == ""){
       kitab = "Kitab Taurat";
    }
    position = game.indexQuestion;

    final charaTeacherImage = game.charaTeacherImage;
    SpriteComponent charaTeacher = SpriteComponent.fromImage(charaTeacherImage)
        ..size = Vector2((230 / charaTeacherImage.height) * charaTeacherImage.width, 230)
        ..position = Vector2(-20, screenHeight)
        ..anchor = Anchor.bottomLeft;

    String text = TextAssets.dQuestion[kitab]?[position]["question"] as String;
    String answer = TextAssets.dQuestion[kitab]?[position]["answer"] as String;
    TextStyle style = const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 18, color: Color(0xFFCFAF8B));

    textQuestion = TextBoxComponent(
      text: text,
      textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 16, color: Color(0xFFCFAF8B))),
      anchor: Anchor.topCenter,
      size: getTextBoxSize(text, style, boardWidth),
      position: Vector2(screenWidth/2, 75),
      align: Anchor.center
    );

    //============ Option ================
    optionButton = [];
    PositionComponent options = PositionComponent(
      anchor: Anchor.topRight,
      position: Vector2(screenWidth/2, textQuestion.y + textQuestion.height + 10)
    );

    final buttonImage = game.buttonImage;

    double py2 = 0;
    for(int i=0; i<4; i++)
    {
      String textTmp = (TextAssets.dQuestion[kitab]?[position]["options"] as List<String>)[i];
      double maxWidth = boardWidth/2 - 10;
      TextStyle styleTmp = const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 16, color: Color(0xFFCFAF8B));
      Vector2 sizeTmp = getTextBoxSize(textTmp, styleTmp, maxWidth);

      if (sizeTmp.y <= 60){
        sizeTmp.y = 60;
      }

      if(i < 2){
        if(py2 < sizeTmp.y){
          py2 = sizeTmp.y;
        }
      }

      optionButton.add(
        TappableComponent(component: PositionComponent(children: [
          SpriteComponent.fromImage(buttonImage,size: sizeTmp - Vector2(10, 10), position: Vector2(5, 5)),
          TextBoxComponent(
            text: textTmp,
            textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 12, color: Color(0xFF7C4917))),
            size: sizeTmp - Vector2(18, 14),
            position: Vector2(7, 5),
            align: Anchor.center
          )
          ],
          size: sizeTmp,
          position: Vector2(-maxWidth/2* pow(-1, i%2), (i >= 2 ? py2 : 0)),
          anchor: Anchor.topCenter
        ), onPressed: () {
          poin.position = Vector2(screenWidth - 50,  screenHeight -50);
          speed = 0;
          if (textTmp == answer){
            int oPoin = TextAssets.dQuestion[kitab]?[position]["true_score"] as int;
            poin.text = "+$oPoin";
            game.score += oPoin;
            FlameAudio.play(Assets.fxCorrect);
          }else{
            int oPoin = TextAssets.dQuestion[kitab]?[position]["false_score"] as int;
            poin.text = "-$oPoin";
            game.score -= oPoin;
            FlameAudio.play(Assets.fxWrong);
          }
          Future.delayed(const Duration(seconds: 1), () {
            isBlockEvent = false;
            game.router.pop();
            game.function();
          });
        },)
      );
    }
    options.addAll(optionButton);

    poin = TextComponent(
      position: Vector2(screenWidth - 50,  screenHeight), 
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 40, color: Color(0xFFCFAF8B))),
      text: "0"
    );

    addAll([
      Background(assetPath: Assets.background4),
      textQuestion,
      charaTeacher,
      options,
      poin
    ]);
    FlameAudio.play(Assets.fxShow);
    return super.onLoad();
  }

  Vector2 getTextBoxSize(String text, TextStyle style, double width){
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: width);
    return Vector2(width, textPainter.height);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void update(double dt) {
    if (game.indexQuestion != position){
      position = game.indexQuestion;
      onLoad();
    }
    if(poin.position.y < game.canvasSize.y + poin.size.y){
      speed += g * dt;
      poin.position.y += speed * dt;
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if(!isBlockEvent){
      for(var button in optionButton){
        if(button.containsPoint(event.devicePosition)){
          button.onTapDown();
        }
      }
    }
    super.onTapDown(event);
  }
  
  @override
  void onTapUp(TapUpEvent event) {
    if(!isBlockEvent){
      for(var button in optionButton){
        if(button.containsPoint(event.devicePosition)){
          isBlockEvent = true;
          button.onTapUp();
        }
      }    
    }
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    for(var button in optionButton){
      button.onTapCancel();
    }
    return super.onTapCancel(event);
  }
}