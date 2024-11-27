

import 'dart:async' as async;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/rendering.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/components/TappableSpriteComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/screens/question.dart';
import 'package:gemai/screens/router.dart';

class HideAndSeek extends Component with TapCallbacks, HasGameRef<RouterGame>{
  late List<TappableSpriteComponent> listBook;
  List<Vector2> bookPosition = [Vector2(-360, 140), Vector2(-100, 140), Vector2(-200, -140), Vector2(-50, -140), Vector2(140, -120), Vector2(-360, -150), Vector2(170, 0), Vector2(360, 60), Vector2(320, 150), Vector2(330, -160)];
  List<bool> found = [false, false, false, false, false, false, false, false, false, false];
  late List<int> threeOf;
  late TextComponent timerLabel;
  late int countdown;
  late async.Timer time;
  bool isBlockEvent = false;

  @override
  async.FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    listBook = [];
    game.function = (){};
    game.score = 0;
    countdown = 120;
    
    var fiveOf = game.getRandomIndices(bookPosition.length, 5);
    threeOf = game.getRandomIndices(fiveOf.length, 3);
    final bookImage = game.bookTauratImage;
    for(var i=0; i<fiveOf.length; i++){
      TappableSpriteComponent book = TappableSpriteComponent(sprite: Sprite(bookImage), onPressed: (){})
            ..anchor = Anchor.center
            ..size = Vector2(bookImage.width * (70 / bookImage.height), 70)
            ..opacity = 0.4
            ..position = bookPosition[fiveOf[i]] + Vector2(screenWidth/2, screenHeight/2)
            ..priority = 0;
      listBook.add(book);
    }

    add(Background(assetPath: Assets.background3)..priority = 0);
    addAll(listBook);
    add(Background(assetPath: Assets.item11)..priority = 0);

    final boardImage = game.boardImage;
    SpriteComponent board = SpriteComponent.fromImage(boardImage)
            ..anchor = Anchor.center
            ..size = Vector2(boardImage.width * (60 / boardImage.height), 60)
            ..position = Vector2(130, 60);
    add(board);

    timerLabel = TextComponent(text: "02:00",
          textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 30, color: Color(0xFFCFAF8B))))
            ..position = Vector2(92, 37);
    add(timerLabel);

    game.dialog = ["Temukan lima buah kita yang tersembunyi", "Semoga beruntung!"];
    game.function = start;
    game.overlays.add("dialog");
    
    game.pauseMainSound();
    game.stopSound();
    game.playSound(Assets.bgm1);
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
        game.nextGame = Route(HideAndSeek.new);
        game.score = 0;
        game.statusGame = "KALAH";
        game.overlays.add("result");
        timer.cancel();
        game.stopSound();
        game.resumeMainSound();
        FlameAudio.play(Assets.fxLose);
      }
    });
    game.book = "Kitab Taurat";
    game.function = (){};
    game.overlays.remove("dialog");
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void update(double dt) async{
    var target = game.canvasSize/2;
    var targetScale = Vector2(3, 3);
    for(var i=0; i<listBook.length; i++){
      if(found[i]){
        if (listBook[i].position != target) {
          Vector2 direction = target - listBook[i].position;
          double distance = direction.length;
          direction.normalize();
          listBook[i].position += direction * 500 * dt;

          if (distance < 5) {
            listBook[i].position = target;
          }
        }else{
          if(listBook[i].opacity != 0){
            var tmp = listBook[i].opacity - 0.01;
            if (tmp <= 0){
              listBook[i].opacity = 0;
            }else{
              listBook[i].opacity = tmp;
            }
          }else{
            // End of all animation
            isBlockEvent = false;
            if(threeOf.contains(i)){
              game.indexQuestion = threeOf.indexOf(i);
              game.router.pushRoute(Route(Question.new));
            }else{
              game.score += 14;
            }

            listBook[i].position.y = 500;
            found[i] = false;
            
            bool flag = true;
            for(var obj in listBook){
              flag = flag && (obj.opacity == 0);
            }
            if(flag){
              time.cancel();
              if(threeOf.contains(i)){
                game.function = () async{
                  game.nextGame = Route(HideAndSeek.new);
                  game.statusGame = "MENANG";
                  game.overlays.add("result");
                  game.stopSound();
                  game.resumeMainSound(); 
                  FlameAudio.play(Assets.fxWin);
                  await game.save("game1", "${game.score}");
                };
              }else{
                game.nextGame = Route(HideAndSeek.new);
                game.statusGame = "MENANG";
                game.overlays.add("result");
                game.stopSound();
                game.resumeMainSound();
                FlameAudio.play(Assets.fxWin);
                await game.save("game1", "${game.score}");
              }
            }
          }
        }
        if(listBook[i].scale != targetScale){
          listBook[i].scale.add(Vector2(0.05, 0.05));
          if((listBook[i].scale.distanceTo(targetScale)).abs() <= 0.5){
            listBook[i].scale = targetScale;
          }
        }
      }
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if(!isBlockEvent){
      for(var button in listBook){
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
      for(var i=0; i<listBook.length; i++){
        if(listBook[i].containsPoint(event.devicePosition)){
          FlameAudio.play(Assets.fxCorrect);
          isBlockEvent = true;
          listBook[i].onTapUp();
          listBook[i].opacity = 1;
          listBook[i].priority = 1;
          found[i] = true;
        }
      }
    }
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    for(var button in listBook){
      button.onTapCancel();
    }
    return super.onTapCancel(event);
  }

}