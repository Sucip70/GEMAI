import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/components/DraggableSpriteAnimComponent.dart';
import 'package:gemai/components/TappableSpriteComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/game/catch.dart';
import 'package:gemai/game/exam.dart';
import 'package:gemai/game/hide_and_seek.dart';
import 'package:gemai/game/puzzle.dart';
import 'package:gemai/game/satan.dart';
import 'package:gemai/screens/knowledge.dart';
import 'package:gemai/screens/router.dart';

class MapPage extends Component with TapCallbacks, HasGameReference<RouterGame>{
  late TappableSpriteComponent nextButton;
  late TappableSpriteComponent homeButton;
  late DraggableSpriteAnimComponent chara;
  List<TappableSpriteComponent> mapsLocation = [];
  late Route route;
  
  @override
  FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    route = Route(Knowledge.new);

    final mapImage = game.mapImage;
    SpriteComponent map = SpriteComponent.fromImage(mapImage)
            ..position = Vector2(screenWidth/2, screenHeight/2)
            ..size = Vector2(mapImage.width * (420 / mapImage.height), 420)
            ..anchor = Anchor.center;

    final nextButtonImage = game.startButtonImage;
    nextButton = TappableSpriteComponent(sprite: Sprite(nextButtonImage), onPressed: () {
      game.router.pushReplacement(route);
    },)
            ..position = Vector2(screenWidth - 60, screenHeight - 30)
            ..size = Vector2(100, nextButtonImage.height * (100/nextButtonImage.width))
            ..anchor = Anchor.center;

    PositionComponent groupLoc = PositionComponent(anchor: Anchor.center, position: Vector2(screenWidth/2, screenHeight/2));

    final loc1Image = game.loc1Image;
    TappableSpriteComponent loc1 = TappableSpriteComponent(sprite: Sprite(loc1Image), onPressed: (){
      chara.target = Vector2(-95, 30);
      nextButton.position = Vector2(game.canvasSize.x*2, game.canvasSize.y - 30);
      game.book = "Kitab Taurat";
      game.nextGame = Route(HideAndSeek.new);
    }, scaleButton: 1)
            ..size = Vector2(loc1Image.width * (60 / loc1Image.height), 60)
            ..position = Vector2(-160, 10);
    groupLoc.add(loc1);
    mapsLocation.add(loc1);

    if(game.get("game1") != ""){
      final loc2Image = game.loc2Image;
      TappableSpriteComponent loc2 = TappableSpriteComponent(sprite: Sprite(loc2Image), onPressed: (){
        chara.target = Vector2(-107, -50);
        nextButton.position = Vector2(game.canvasSize.x*2, game.canvasSize.y - 30);
        game.book = "Kitab Zabur";
        game.nextGame = Route(Puzzle.new);
        route = Route(Knowledge.new);
      }, scaleButton: 1)
              ..size = Vector2(loc2Image.width * (120 / loc2Image.height), 120)
              ..position = Vector2(-174, -60);
      groupLoc.add(loc2);
      mapsLocation.add(loc2);
    }

    if(game.get("game2") != ""){
      final loc3Image = game.loc3Image;
      TappableSpriteComponent loc3 = TappableSpriteComponent(sprite: Sprite(loc3Image), onPressed: (){
        chara.target = Vector2(0, -50);
        nextButton.position = Vector2(game.canvasSize.x*2, game.canvasSize.y - 30);
        game.book = "Kitab Injil";
        game.nextGame = Route(Catch.new);
        route = Route(Knowledge.new);
      }, scaleButton: 1)
              ..size = Vector2(loc3Image.width * (90 / loc3Image.height), 90)
              ..position = Vector2(-100, -75);
      groupLoc.add(loc3);
      mapsLocation.add(loc3);
    }

    if(game.get("game3") != ""){
      final loc4Image = game.loc4Image;
      TappableSpriteComponent loc4 = TappableSpriteComponent(sprite: Sprite(loc4Image), onPressed: (){
        chara.target = Vector2(30, 0);
        nextButton.position = Vector2(game.canvasSize.x*2, game.canvasSize.y - 30);
        game.book = "Kitab Al-Qur'an";
        game.nextGame = Route(Satan.new);
        route = Route(Knowledge.new);
      }, scaleButton: 1)
              ..size = Vector2(loc4Image.width * (90 / loc4Image.height), 90)
              ..position = Vector2(-37, -20);
      groupLoc.add(loc4);
      mapsLocation.add(loc4);
    }

    if(game.get("game4") != ""){
      final loc5Image = game.loc5Image;
      TappableSpriteComponent loc5 = TappableSpriteComponent(sprite: Sprite(loc5Image), onPressed: (){
        chara.target = Vector2(110, -25);
        nextButton.position = Vector2(game.canvasSize.x*2, game.canvasSize.y - 30);
        route = Route(Exam.new);
      }, scaleButton: 1)
              ..size = Vector2(loc5Image.width * (140 / loc5Image.height), 140)
              ..position = Vector2(40, -70);
      groupLoc.add(loc5);
      mapsLocation.add(loc5);
    }

    final animImage = game.chara=="GHEA"?game.gheaAnim:game.kalaAnim;
    final charaImage = game.chara=="GHEA"?game.charaGheaImage:game.charaKalaImage;
    chara = DraggableSpriteAnimComponent(animation: animImage, index: Vector2(0, 0), onPressed: (){})
            ..size = Vector2(charaImage.width * (40 / charaImage.height), 40)
            ..position = Vector2(-95, 30)
            ..target = Vector2(-95, 30);
    groupLoc.add(chara);
    
    //init, then change to latest
    if(game.get("game1") == ""){
      chara.target = Vector2(-95, 30);
      game.book = "Kitab Taurat";
      game.nextGame = Route(HideAndSeek.new);
    }else if(game.get("game2") == ""){
      chara.position = Vector2(-95, 30);
      chara.target = Vector2(-107, -50);
      game.book = "Kitab Zabur";
      game.nextGame = Route(Puzzle.new);
      route = Route(Knowledge.new);
    }else if(game.get("game3") == ""){
      chara.position = Vector2(-107, -50);
      chara.target = Vector2(0, -50);
      game.book = "Kitab Injil";
      game.nextGame = Route(Catch.new);
      route = Route(Knowledge.new); 
    }else if(game.get("game4") == ""){
      chara.position = Vector2(0, -50);
      chara.target = Vector2(30, 0);
      game.book = "Kitab Al-Qur'an";
      game.nextGame = Route(Satan.new);
      route = Route(Knowledge.new);
    }else if(game.get("exam") == ""){
      chara.position = Vector2(30, 0);
      chara.target = Vector2(110, -25);
      route = Route(Exam.new);
    }else{
      chara.target = Vector2(110, -25);
      chara.position = Vector2(110, -25);
      route = Route(Exam.new);
    }

    addAll([
      Background(assetPath: Assets.background5),
      map,
      nextButton,
      groupLoc,
    ]);

    final buttonHomeImage = game.buttonHomeImage;
    homeButton = TappableSpriteComponent(sprite: Sprite(buttonHomeImage), onPressed: (){
      game.router.pop();
    })
            ..size = Vector2(buttonHomeImage.width * (50/buttonHomeImage.height), 50)
            ..position = Vector2(30, 10);
    add(homeButton);

    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void update(double dt) {
    if (chara.position != chara.target) {
      Vector2 direction = chara.target - chara.position;
      double distance = direction.length;
      direction.normalize();
      chara.position += direction * 200 * dt;

      // Stop moving once we're close enough to the target
      if (distance < 5) {
        chara.position = chara.target;
        chara.isMoveable = false;
        nextButton.position = Vector2(game.canvasSize.x - 60, game.canvasSize.y - 30);
      }
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if(nextButton.containsPoint(event.devicePosition)){
      nextButton.onTapDown();
    }
    if(homeButton.containsPoint(event.devicePosition)){
      homeButton.onTapDown();
    }
    for(var loc in mapsLocation){
      if(loc.containsPoint(event.devicePosition)){
        loc.onTapDown();
      }
    }    
    super.onTapDown(event);
  }
  
  @override
  void onTapUp(TapUpEvent event) {
    if(nextButton.containsPoint(event.devicePosition)){
      nextButton.onTapUp();
      FlameAudio.play(Assets.fxClick);
    }
    if(homeButton.containsPoint(event.devicePosition)){
      homeButton.onTapUp();
      FlameAudio.play(Assets.fxClick);
    }
    for(var loc in mapsLocation){
      if(loc.containsPoint(event.devicePosition)){
        loc.onTapUp();
        FlameAudio.play(Assets.fxClick);
      }
    }
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    nextButton.onTapCancel();
    homeButton.onTapCancel();
    for(var loc in mapsLocation){
      loc.onTapCancel();
    }
    return super.onTapCancel(event);
  }
}