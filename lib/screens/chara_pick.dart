import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart' as w;
import 'package:gemai/comgen/textassets.dart';
import 'package:gemai/components/TappableSpriteAnimComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/screens/map.dart';
import 'package:gemai/screens/router.dart' as route;

class CharaPick extends Component with TapCallbacks, HasGameReference<route.RouterGame>{
  late PositionComponent ghea;
  late PositionComponent kala;

  @override
  FutureOr<void> onLoad() {    
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;

    const gap = 120;

    TappableSpriteAnimComponent charaGhea = TappableSpriteAnimComponent(animation: game.gheaAnim, onPressed: (){})
        ..size = Vector2((230 / game.charaGheaImage.height) * game.charaGheaImage.width, 230);

    TappableSpriteAnimComponent charaKala = TappableSpriteAnimComponent(animation: game.kalaAnim, onPressed: (){})
        ..size = Vector2((230 / game.charaKalaImage.height) * game.charaKalaImage.width, 230);

    final titleImage = game.titleImage;
    SpriteComponent title = SpriteComponent.fromImage(titleImage)
        ..size = Vector2(500, 50)
        ..anchor = Anchor.center;

    TextComponent textTitle = TextComponent(
      text: "Pilih Karakter Mu!",
      textRenderer: TextPaint(style: const w.TextStyle(fontFamily: Assets.fontPrimary, fontSize: 30, color: Color(0xFFCFAF8B))),
      anchor: Anchor.center,
    );

    final boxGheaImage = game.titleImage;
    SpriteComponent boxGhea = SpriteComponent.fromImage(boxGheaImage)
        ..size = Vector2(120, 35)
        ..position = Vector2(-12, charaGhea.height + 17)
        ..anchor = Anchor.centerLeft; 

    final boxKalaImage = game.titleImage;
    SpriteComponent boxKala = SpriteComponent.fromImage(boxKalaImage)
        ..size = Vector2(120, 35)
        ..position = Vector2(-7, charaKala.height + 17)
        ..anchor = Anchor.centerLeft;  

    TextComponent textGhea = TextComponent(
      text: "GHEA",
      textRenderer: TextPaint(style: const w.TextStyle(fontFamily: Assets.fontPrimary, fontSize: 19, color: Color(0xFFCFAF8B))),
      position: Vector2(-12 + boxGhea.width/2, charaGhea.height + 17),
      anchor: Anchor.center
    );

    TextComponent textKala = TextComponent(
      text: "KALA",
      textRenderer: TextPaint(style: const w.TextStyle(fontFamily: Assets.fontPrimary, fontSize: 19, color: Color(0xFFCFAF8B))),
      position: Vector2(-7 + boxKala.width/2, charaKala.height + 17),
      anchor: Anchor.center
    );

    ghea = PositionComponent(children: [charaGhea, boxGhea, textGhea], position: Vector2(screenWidth/2 - gap, screenHeight/2 + 15), size: Vector2(charaGhea.width, 260), anchor: Anchor.center);
    kala = PositionComponent(children: [charaKala, boxKala, textKala], position: Vector2(screenWidth/2 + gap, screenHeight/2 + 15), size: Vector2(charaKala.width, 260), anchor: Anchor.center);

    addAll([
      Background(assetPath: Assets.background5),
      ghea,
      kala,
      PositionComponent(children: [title, textTitle], position: Vector2(screenWidth/2, 30)),
    ]);
    
    FlameAudio.play(Assets.fxPilih);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    if(ghea.containsPoint(event.devicePosition)){
      game.chara = "GHEA";
      game.dialog = TextAssets.dialogCharaPick;
      game.function = (){game.router.pushReplacement(Route(MapPage.new));};
      game.overlays.add("dialog");
      FlameAudio.play(Assets.fxClick);
    }
    if(kala.containsPoint(event.devicePosition)){
      game.chara = "KALA";
      game.dialog = TextAssets.dialogCharaPick;
      game.function = (){game.router.pushReplacement(Route(MapPage.new));};
      game.overlays.add("dialog");
      FlameAudio.play(Assets.fxClick);
    }
    super.onTapDown(event);
  }
}
