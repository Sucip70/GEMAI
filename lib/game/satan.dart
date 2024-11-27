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

class Satan extends Component with TapCallbacks, HasGameRef<RouterGame>{
  late PositionComponent player;
  List<SpriteComponent> bullets = [];
  List<SpriteComponent> enemies1 = [];
  List<SpriteComponent> enemies2 = [];
  double gravity = 400;
  double flapStrength = 200;
  double speed = 0;
  late bool isStart;
  List<double> speedE = [];
  List<int> lifeTimeE = [];
  late List<int> threeOf;

  // late RectangleComponent rect;
  // List<RectangleComponent> rect1 = [];
  // List<RectangleComponent> rect2 = [];

  @override
  async.FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    bullets = [];
    enemies1 = [];
    enemies2 = [];
    speed = 0;
    speedE = [];
    lifeTimeE = [];
    game.score = 0;

    threeOf = game.getRandomIndices(30, 3);

    final charaImage = game.chara=="GHEA"?game.charaGheaImage:game.charaKalaImage;
    SpriteComponent chara = SpriteComponent.fromImage(charaImage)
            ..size = Vector2(charaImage.width * (80 / charaImage.height), 80);

    final bubbleImage = game.bubbleImage;
    SpriteComponent bubble = SpriteComponent.fromImage(bubbleImage)
            ..size = Vector2(bubbleImage.width * (180 / bubbleImage.height), 180);

    bubble.position.sub(bubble.size - chara.size);
    bubble.position.divide(Vector2(2, 2));

    player = PositionComponent(children: [chara, bubble])
            ..anchor = Anchor.center
            ..size = Vector2(charaImage.width * (80 / charaImage.height), 80)
            ..position = Vector2(150, screenHeight - 100);

    addAll([
      Background(assetPath: Assets.background6),
      player,
    ]);

    final satan1Image = game.satan1Image;
    final satan2Image = game.satan2Image;
    Random r = Random();
    List<int> order = game.getRandomIndices(40, 30);
    for(var i=0; i<40; i++){
      SpriteComponent enemy;
      if(order.contains(i)){
        enemy = SpriteComponent.fromImage(satan1Image)
                ..anchor = Anchor.center
                ..size = Vector2(satan1Image.width * (80 / satan1Image.height), 80)
                ..position = Vector2(screenWidth + 200*i, screenHeight - 50);
        enemy.flipHorizontally(); 
        enemies1.add(enemy);
        speedE.add(r.nextDouble()*-400);
      }else{
        enemy = SpriteComponent.fromImage(satan2Image)
                ..anchor = Anchor.center
                ..size = Vector2(satan2Image.width * (150 / satan2Image.height), 150)
                ..position = Vector2(screenWidth + 300*i, 100);
        enemies2.add(enemy);
        lifeTimeE.add(5);
      }
      add(enemy);
    }

    isStart = false;
    game.dialog = ["Para setan sedang menuju kemari", "Serang dengan kekuatan do'a"];
    game.function = (){
      game.book = "Kitab Al-Qur'an";
      isStart = true;
      game.overlays.remove("dialog");
    };
    game.overlays.add("dialog");
    
    game.pauseMainSound();
    game.stopSound();
    game.playSound(Assets.bgm4);
    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void update(double dt) async {
    if(isStart){
      speed += gravity * dt;
      player.position.y += speed * dt;

      // Prevent the bird from falling off the screen
      if (player.position.y > game.canvasSize.y - player.height/2) {
        player.position.y = game.canvasSize.y - player.height/2;
        speed = 0;
      }else if(player.position.y < player.height/2){
        player.position.y = player.height/2;
      }

      for(var i=0; i<bullets.length; i++){
        if(bullets[i].isRemoved)continue;

        bullets[i].position.add(Vector2(4, 0));
        if(bullets[i].position.x > game.canvasSize.x/4*3){
          bullets[i].removeFromParent();
          continue;
        }

        for(var j=0; j<enemies1.length; j++){
          if(enemies1[j].isRemoved)continue; 

          double rad = bullets[i].width/2 + enemies1[j].width/2 - 10;
          if(bullets[i].position.distanceTo(enemies1[j].position-Vector2(0, enemies1[j].height/2)) <= rad){
            enemies1[j].removeFromParent();
            bullets[i].removeFromParent();
            FlameAudio.play(Assets.fxWrong);

            if(threeOf.contains(j)){
              isStart = false;
              game.function = (){isStart = true;};
              game.indexQuestion = threeOf.indexOf(j);
              game.router.pushRoute(Route(Question.new));
            }else{
              game.score += 1;
            }
          }
        }

        for(var j=0; j<enemies2.length; j++){
          if(enemies2[j].isRemoved)continue;

          double rad = bullets[i].width/2 + enemies2[j].width/2 - 10;
          if(bullets[i].position.distanceTo(enemies2[j].position-Vector2(0, enemies2[j].height/2)) <= rad){
            if(lifeTimeE[j] > 0){
              lifeTimeE[j]--;
              enemies2[j].size.multiply(Vector2(.8, .8));
            }else{
              enemies2[j].removeFromParent();
              game.score += 2;
            }
            bullets[i].removeFromParent();
            FlameAudio.play(Assets.fxWrong);
          }
        }
      }

      for(var i=0; i<enemies1.length; i++){
        if(enemies1[i].isRemoved)continue;
        enemies1[i].position.sub(Vector2(0.8, 0));

        if(enemies1[i].position.x < 100){
          game.nextGame = Route(Satan.new);
          enemies1[i].removeFromParent();
          isStart = false;
          game.score = 0;
          game.statusGame = "KALAH";
          game.overlays.add("result");
          game.stopSound();
          game.resumeMainSound();
          FlameAudio.play(Assets.fxLose);
          continue;
        }

        if(speedE[i] < 0 && speedE[i] + gravity * dt >=0){
          enemies1[i].sprite = Sprite(game.satan1Image);
        }

        speedE[i] += gravity * dt;
        enemies1[i].position.y += speedE[i] * dt;

        if (enemies1[i].position.y > game.canvasSize.y - enemies1[i].height/2) {
          enemies1[i].position.y = game.canvasSize.y - enemies1[i].height/2;
          speedE[i] = -500;
          enemies1[i].sprite = Sprite(game.satan11Image);
        }

        if(enemies1[i].containsPoint(player.position)){
          game.nextGame = Route(Satan.new);
          enemies1[i].removeFromParent();
          isStart = false;
          game.score = 0;
          game.statusGame = "KALAH";
          game.overlays.add("result");
          game.stopSound();
          game.resumeMainSound();
          FlameAudio.play(Assets.fxLose);
          continue;
        }
      }

      for(var i=0; i<enemies2.length; i++){
        if(enemies2[i].isRemoved)continue;
        // rect2[i].position = enemies2[i].position;
        // rect2[i].size = enemies2[i].size;

        double h = 0;
        if(game.canvasSize.x > enemies2[i].position.x){
          h = -sin(game.canvasSize.x/10000);
        }
        enemies2[i].position.sub(Vector2(1.2, h));
        if(enemies2[i].position.x < 100){
          game.nextGame = Route(Satan.new);
          enemies2[i].removeFromParent();isStart = false;
          game.score = 0;
          game.statusGame = "KALAH";
          game.overlays.add("result");
          game.stopSound();
          game.resumeMainSound();
          FlameAudio.play(Assets.fxLose);
          continue;
        }

        if(enemies2[i].containsPoint(player.position)){
          game.nextGame = Route(Satan.new);
          enemies2[i].removeFromParent();
          isStart = false;
          game.score = 0;
          game.statusGame = "KALAH";
          game.overlays.add("result");
          game.stopSound();
          game.resumeMainSound();
          FlameAudio.play(Assets.fxLose);
          continue;
        }
      }
    
      bool flag = true;
      for(var b in enemies1){
        flag = flag && b.isRemoved;
      }
      for(var b in enemies2){
        flag = flag && b.isRemoved;
      }
      if(flag){
        game.nextGame = Route(Satan.new);
        game.stopSound();
        game.resumeMainSound();
        FlameAudio.play(Assets.fxWin);
        isStart = false;
        game.statusGame = "MENANG";
        game.overlays.add("result");
        await game.save("game4", "${game.score}");
      }
    }
    
    super.update(dt);
  
  
  }

  @override
  void onTapDown(TapDownEvent event) {
    speed = -flapStrength;
    FlameAudio.play(Assets.fxShot);
    super.onTapDown(event);
  }
  
  @override
  void onTapUp(TapUpEvent event) async {
    final bulletImage = game.bulletImage;
    SpriteComponent bullet = SpriteComponent.fromImage(bulletImage)
            ..size = Vector2(bulletImage.width * (50 / bulletImage.height), 50)
            ..position = player.position - Vector2(0, 20);
    add(bullet);
    bullets.add(bullet);
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    return super.onTapCancel(event);
  }
}