import 'dart:async' as async;
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

class Exam extends Component with TapCallbacks, HasGameReference<RouterGame>{
  late List<TappableComponent> optionButton;
  late TextComponent poin;
  late TextBoxComponent textQuestion;
  late List<TextBoxComponent> textOptions;
  late List<SpriteComponent> imageOptions;
  late PositionComponent options;
  double g = 100;
  double speed = 0;
  bool isBlockEvent = false;
  List<int> logQuestion = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  late TextComponent timerLabel;
  late async.Timer time;
  int countdown = 600;
  bool firstStart = true;

  @override
  async.FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    const boardWidth = 440.0;
    textOptions = [];
    imageOptions = [];

    List<int> order = game.getRandomIndices(logQuestion.length, 1);
    int position = logQuestion[order[0]];

    logQuestion.remove(position);
    
    String kitab = getKitab(position);

    String text = TextAssets.dQuestion[kitab]?[position%3]["question"] as String;
    String answer = TextAssets.dQuestion[kitab]?[position%3]["answer"] as String;
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
    options = PositionComponent(
      anchor: Anchor.topRight,
      position: Vector2(screenWidth/2, textQuestion.y + textQuestion.height + 10)
    );

    final buttonImage = game.buttonImage;

    double py2 = 0;
    for(int i=0; i<4; i++)
    {
      String textTmp = (TextAssets.dQuestion[kitab]?[position%3]["options"] as List<String>)[i];
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

      var opt = TextBoxComponent(
        text: textTmp,
        textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 12, color: Color(0xFF7C4917))),
        size: sizeTmp - Vector2(18, 14),
        position: Vector2(7, 5),
        align: Anchor.center
      );
      textOptions.add(opt);

      SpriteComponent imgOpt = SpriteComponent.fromImage(buttonImage,size: sizeTmp - Vector2(10, 10), position: Vector2(5, 5));
      imageOptions.add(imgOpt);

      TappableComponent optBtn = TappableComponent(component: PositionComponent(children: [
          imgOpt,
          opt
        ],
        size: sizeTmp,
        position: Vector2(-maxWidth/2* pow(-1, i%2), (i >= 2 ? py2 : 0)),
        anchor: Anchor.topCenter
      ), onPressed: () {
          poin.position = Vector2(screenWidth - 50,  screenHeight -50);
          speed = 0;
          if (textTmp == answer){
            int oPoin = 20;
            poin.text = "+$oPoin";
            game.score += oPoin;
            FlameAudio.play(Assets.fxCorrect);
          }else{
            int oPoin = 5;
            poin.text = "-$oPoin";
            game.score -= oPoin;
            FlameAudio.play(Assets.fxWrong);
          }
          Future.delayed(const Duration(seconds: 1), () async{
            isBlockEvent = false;
            onLoad();
            if(logQuestion.isEmpty){
              time.cancel();
              game.statusGame = "MENANG";
              game.overlays.add("result");
              game.stopSound();
              game.resumeMainSound();
              FlameAudio.play(Assets.fxWin);
              await game.save("exam", "${game.score}");
            }
          });
        },);
      
      optionButton.add(optBtn);
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
      // charaTeacher,
      options,
      poin
    ]);

    final boardImage = game.boardImage;
    SpriteComponent board = SpriteComponent.fromImage(boardImage)
            ..anchor = Anchor.center
            ..size = Vector2(boardImage.width * (60 / boardImage.height), 60)
            ..position = Vector2(120, 50);
    add(board);

    final minutes = (countdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (countdown % 60).toString().padLeft(2, '0');
    timerLabel = TextComponent(text: "$minutes:$seconds",
          textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 30, color: Color(0xFFCFAF8B))))
            ..position = Vector2(82, 27);
    add(timerLabel);

    if(firstStart){
      countdown = 600;
      game.score = 0;
      firstStart = false;

      game.dialog = ["Yeay, kita ada di akhir perjalanan!", "Ayo jawab lagi tantangannya", "Yang teliti ya!"];
      game.function = start;
      game.overlays.add("dialog");

      game.pauseMainSound();
      game.stopSound();
      game.playSound(Assets.bgm5);
    }

    return super.onLoad();
  }

  void start(){
    time = async.Timer.periodic(const Duration(seconds: 1), (timer){
      if (countdown > 0) {
        countdown--;
        final minutes = (countdown ~/ 60).toString().padLeft(2, '0');
        final seconds = (countdown % 60).toString().padLeft(2, '0');
        timerLabel.text = "$minutes:$seconds";
      } else {
        game.score = 0;
        game.statusGame = "KALAH";
        game.overlays.add("result");
        timer.cancel();
        game.stopSound();
        game.resumeMainSound();
        FlameAudio.play(Assets.fxLose);
      }
    });
    game.function = (){};
    game.overlays.remove("dialog");
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
    if(poin.position.y < game.canvasSize.y + poin.size.y){
      speed += g * dt;
      poin.position.y += speed * dt;
    }
    super.update(dt);
  }

  String getKitab(int index){
    if(index < 3){
      return "Kitab Taurat";
    }else if(index < 6){
      return "Kitab Zabur";
    }else if(index < 9){
      return "Kitab Injil";
    }else if(index < 12){
      return "Kitab Al-Qur'an";
    }
    return "";
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