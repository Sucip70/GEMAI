import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gemai/components/TappableSpriteComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/screens/router.dart';

class Home extends Component with TapCallbacks, HasGameReference<RouterGame>{
  late TappableSpriteComponent nextButton;
  late SpriteComponent title;

  @override
  FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;

    final titleImage = game.title;
    const wTitle = 650.0;  
    final hTitle = (wTitle / titleImage.width) * titleImage.height;
    final centerX = (screenWidth - wTitle) / 2;
    final centerY = (screenHeight - hTitle) / 2;
    title = SpriteComponent.fromImage(titleImage)
            ..position = Vector2(centerX, centerY)
            ..size = Vector2(wTitle, hTitle);

    final nextButtonImage = game.startButtonImage;
    const wNextButton = 100.0;  
    const mrNextButton = 10.0;
    const mbNextButton = 10.0;
    final hNextButton = (wNextButton / nextButtonImage.width) * nextButtonImage.height;
    nextButton = TappableSpriteComponent(sprite: Sprite(nextButtonImage), onPressed: () {
      game.router.pushNamed('board');
    },)
            ..position = Vector2(screenWidth - wNextButton/2 - mrNextButton, screenHeight - hNextButton/2 - mbNextButton)
            ..size = Vector2(wNextButton, hNextButton)
            ..anchor = Anchor.center;
    
    addAll([Background(assetPath: Assets.background1)
      , title, nextButton]);

    game.playMainSound();
    FlameAudio.play(Assets.fxGemai);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    if(nextButton.containsPoint(event.devicePosition)){
      nextButton.onTapDown();
    }
    super.onTapDown(event);
  }
  
  @override
  void onTapUp(TapUpEvent event) {
    if(nextButton.containsPoint(event.devicePosition)){
      nextButton.onTapUp();
      FlameAudio.play(Assets.fxClick);
    }
    return super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    nextButton.onTapCancel();
    return super.onTapCancel(event);
  }
}