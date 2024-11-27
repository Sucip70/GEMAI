import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/screens/question.dart';
import 'package:gemai/screens/router.dart';

class Catch extends Component with TapCallbacks, HasGameRef<RouterGame>{
  late SpriteComponent chara;
  late List<SpriteComponent> drips;
  late List<SpriteComponent> books;
  int command = 0;
  double speed = 5;
  late List<int> threeOf;
  late TextComponent timerLabel;
  late async.Timer time;
  late int countdown;
  late bool isStart;

  @override
  async.FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    drips = [];
    books = [];
    countdown = 180;
    game.score = 0;
        
    threeOf = game.getRandomIndices(10, 3);
    
    final charaImage = game.chara=="GHEA"?game.charaGheaImage:game.charaKalaImage;
    chara = SpriteComponent.fromImage(charaImage)
            ..size = Vector2(charaImage.width * (160 / charaImage.height), 160)
            ..position = Vector2(screenWidth/2, screenHeight - 210);

    final bookImage = game.bookInjilImage;
    final dripImage = game.dripImage;

    double widthArea = screenWidth - 100;
    Vector2 obsArea = Vector2(widthArea/5, 700);
    Random r = Random();
    for(int j=0; j<10; j++){
      var iBook = r.nextInt(5);
      for(int i=0; i<5; i++){
        var sprt = iBook == i ? bookImage : dripImage;
        double size = iBook == i ? 50 : 100;
        final drip = SpriteComponent.fromImage(sprt)
                ..anchor = Anchor.bottomCenter
                ..size = Vector2(sprt.width * (size / sprt.height), size)
                ..position = Vector2(obsArea.x*i - widthArea/2 + r.nextDouble()*obsArea.x, -r.nextDouble()*obsArea.y - obsArea.y*j); 
        if(iBook == i){
          books.add(drip);
        }else{
          drips.add(drip);
        }
      }
    }
    
    PositionComponent groupDrip = PositionComponent(children: drips, anchor: Anchor.center, position: Vector2(screenWidth/2, 0));
    PositionComponent groupBook = PositionComponent(children: books, anchor: Anchor.center, position: Vector2(screenWidth/2, 0));

    addAll([
      Background(assetPath: Assets.background7),
      chara,
      groupDrip,
      groupBook
    ]);

    isStart = false;
    game.dialog = ["Awas, lihat langit langit!", "Tekan layar bagian kanan dan kiri untuk menghindar", "Hati-hati ya!"];
    game.function = (){
      game.book = "Kitab Injil";
      isStart = true;
      game.overlays.remove("dialog");
    };
    game.overlays.add("dialog");
    
    game.pauseMainSound();
    game.stopSound();
    game.playSound(Assets.bgm3);
    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void update(double dt) async{
    if(isStart){
      if(command < 0){
        if(chara.position.x < game.canvasSize.x - 100){
          chara.position.sub(Vector2(-speed, 0));
        }
      }
      else if(command > 0){
        if(chara.position.x > 0){
          chara.position.sub(Vector2(speed, 0));
        }
      }
      List<int> junk = [];
      for(var i=0; i<drips.length; i++){
        drips[i].position.add(Vector2(0, 1.2));
        if(drips[i].position.y > game.canvasSize.y - 50){
          drips[i].removeFromParent();
          junk.add(i);
        }

        if(chara.containsPoint(drips[i].position + Vector2(game.canvasSize.x/2, 0))){
          drips[i].removeFromParent();
          junk.add(i);
          isStart = false;
          game.score = 0;
          game.statusGame = "KALAH";
          game.nextGame = Route(Catch.new);
          game.function = (){
          };
          game.overlays.add("result");
          game.stopSound();
          game.resumeMainSound();
          FlameAudio.play(Assets.fxLose);
        }
      }
      for(var j in junk){
        drips.removeAt(j);
      }

      for(var i=0; i<books.length; i++){
        if(books[i].isRemoved)continue;
        books[i].position.add(Vector2(0, 1.2));
        if(books[i].position.y > game.canvasSize.y - 50){
          books[i].removeFromParent();
        }

        if(chara.containsPoint(books[i].position + Vector2(game.canvasSize.x/2, 0))){
          FlameAudio.play(Assets.fxCorrect);
          books[i].removeFromParent();
          if(threeOf.contains(i)){
            isStart = false;
            game.function = (){isStart = true;};
            game.indexQuestion = threeOf.indexOf(i);
            game.router.pushRoute(Route(Question.new));
          }else{
            game.score += 4;
          }
        }
      }
      bool flag = true;
      for(var b in books){
        flag = flag && b.isRemoved;
      }
      if(drips.isEmpty && flag && !game.overlays.isActive("result") ){
        game.nextGame = Route(Catch.new);
        game.statusGame = "MENANG";
        game.overlays.add("result");
        game.stopSound();
        game.resumeMainSound();
        FlameAudio.play(Assets.fxWin);
        await game.save("game3", "${game.score}");
      }
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final screenSize = game.canvasSize.clone();
    if(event.devicePosition.x < screenSize.x/2){
      command = 1;
    }else{
      command = -1;
    }
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    command = 0;
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    command = 0;
    return super.onTapCancel(event);
  }
}