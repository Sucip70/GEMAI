import 'dart:async' as async;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/components/DraggableSpriteComponent.dart';
import 'package:gemai/components/background.dart';
import 'package:gemai/screens/question.dart';
import 'package:gemai/screens/router.dart';

class Puzzle extends Component with TapCallbacks, DragCallbacks, HasGameRef<RouterGame>{
  late List<DraggableSpriteComponent> puzzles;
  late List<int> threeOf;
  late TextComponent timerLabel;
  late async.Timer time;
  late int countdown;

  List<List<Vector2>> positionPuzzle = [
    <Vector2>[Vector2(-84.5, 135.5), Vector2(-28.5, 141), Vector2(34.2, 135.5), Vector2(84, 142)],//62
    <Vector2>[Vector2(-84.5, 85.5), Vector2(-34.5, 92), Vector2(21.5, 79), Vector2(77.5, 85.5)],
    <Vector2>[Vector2(-78, 28.5), Vector2(-28, 35), Vector2(22, 28.5), Vector2(78.5, 22)],
    <Vector2>[Vector2(-84.5, -35), Vector2(-28, -21.4), Vector2(35, -22), Vector2(85, -28.5)],
    <Vector2>[Vector2(-78, -85), Vector2(-22, -78.5), Vector2(28.5, -86), Vector2(78.5, -86)],
    <Vector2>[Vector2(-78, -135), Vector2(-28.3, -135), Vector2(22, -141.5), Vector2(78.5, -141.5)],
  ];

  List<List<double>> sizePuzzle = [
    [70, 57, 70, 57],
    [57, 70, 70, 83],
    [83, 70, 57, 70],
    [70, 70, 70, 57],
    [57, 70, 83, 83],
    [70, 70, 57, 57],
  ];

  @override
  async.FutureOr<void> onLoad() {
    final screenSize = game.canvasSize;
    final screenWidth = screenSize.x;
    final screenHeight = screenSize.y;
    puzzles = [];
    countdown = 180;
    game.score = 0;
    
    threeOf = game.getRandomIndices(24, 3);
    
    for(var i=0; i<positionPuzzle.length; i++){
      for(var j=0; j<positionPuzzle[i].length; j++){
        final puzzleImage = Flame.images.fromCache("puzzle${i+1}${j+1}.png");
        DraggableSpriteComponent puzzle = DraggableSpriteComponent(sprite: Sprite(puzzleImage), onPressed: (){}, index: Vector2(i.toDouble(), j.toDouble()))
              ..anchor = Anchor.center
              ..size = Vector2(puzzleImage.width * (sizePuzzle[i][j] / puzzleImage.height), sizePuzzle[i][j])
              ..position = positionPuzzle[i][j]
              ..target = positionPuzzle[i][j];
        puzzles.add(puzzle);
      }
    }

    PositionComponent groupPuzzle = PositionComponent(anchor: Anchor.center, position: Vector2(screenWidth/2, screenHeight/2));
    groupPuzzle.addAll(puzzles);

    RectangleComponent rect = RectangleComponent(anchor: Anchor.center, position: Vector2(screenWidth/2, screenHeight/2), size: Vector2(225, 340), paint: Paint()..color = const Color.fromARGB(127, 0, 0, 0));

    addAll([
      Background(assetPath: Assets.background8),
      rect,
      groupPuzzle,
    ]);

    randPuzzle();

    final boardImage = game.boardImage;
    SpriteComponent board = SpriteComponent.fromImage(boardImage)
            ..anchor = Anchor.center
            ..size = Vector2(boardImage.width * (60 / boardImage.height), 60)
            ..position = Vector2(130, 60);
    add(board);

    timerLabel = TextComponent(text: "03:00",
          textRenderer: TextPaint(style: const TextStyle(fontFamily: Assets.fontPrimary, fontSize: 30, color: Color(0xFFCFAF8B))))
            ..position = Vector2(92, 37);
    add(timerLabel);

    game.dialog = ["Ayo susun kembali potongan puzzle", "Semangat kamu bisa!"];
    game.function = start;
    game.overlays.add("dialog");

    game.pauseMainSound();
    game.stopSound();
    game.playSound(Assets.bgm2);
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
        game.nextGame = Route(Puzzle.new);
        game.score = 0;
        game.statusGame = "KALAH";
        game.overlays.add("result");
        timer.cancel();
        game.stopSound();
        game.resumeMainSound();
        FlameAudio.play(Assets.fxLose);
      }
    });
    game.book = "Kitab Zabur";
    game.function = (){};
    game.overlays.remove("dialog");
  }

  void randPuzzle(){
    for(var button in puzzles){
      final screenSize = game.canvasSize.clone();
      screenSize.multiply(Vector2.random() - Vector2(0.5, 0.5));
      button.target = screenSize*0.8;
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
  }

  @override 
  void onDragStart(DragStartEvent event) {
    var index = -1;
    double maxLong = double.infinity;
    for(var i=0; i<puzzles.length; i++){
      puzzles[i].isDraggable = false;
      var dis = puzzles[i].position.distanceTo(event.devicePosition);
      if(dis < maxLong && puzzles[i].containsPoint(event.devicePosition) && !puzzles[i].isLock){
        index = i;
        maxLong = dis;
      }
    }  
    if(index != -1){
      puzzles[index].isDraggable = true;
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    // Update position based on drag movement
    for(var button in puzzles){
      if(button.isDraggable){
        button.onDragUpdate(event);
      }
    }
  }

  @override 
  void onDragEnd(DragEndEvent event) async {
    for(var button in puzzles){
      if(button.isLock)continue;
      button.isDraggable = false;
      var i = button.index;
      int j = (i.x * 4 + i.y).toInt();
      if(button.position.distanceTo(positionPuzzle[i.x.toInt()][i.y.toInt()]) < 10){
        button.position = positionPuzzle[i.x.toInt()][i.y.toInt()];
        button.isLock = true;

        FlameAudio.play(Assets.fxCorrect);
        if(threeOf.contains(j)){
          game.indexQuestion = threeOf.indexOf(j);
          game.router.pushRoute(Route(Question.new));
        }else{
          game.score += 2;
        }

        bool flag = true;
        for(var obj in puzzles){
          flag = flag && obj.isLock;
        }
        if(flag){
          time.cancel();
          if(threeOf.contains(j)){
            game.function = () async {
              game.nextGame = Route(Puzzle.new);
              game.statusGame = "MENANG";
              game.overlays.add("result");
              game.stopSound();
              game.resumeMainSound();
              FlameAudio.play(Assets.fxWin);
              await game.save("game2", "${game.score}");
            };
          }else{
            game.statusGame = "MENANG";
            game.overlays.add("result");
            game.stopSound();
            game.resumeMainSound();
            FlameAudio.play(Assets.fxWin);
            await game.save("game2", "${game.score}");
          }
        }
      }
    }  
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    for(var button in puzzles){
      button.isDraggable = false;
    }  
    super.onDragCancel(event);
  }

  @override 
  void update(double dt) {
    for(var button in puzzles){
      if (button.position != button.target && button.isMoveable) {
        Vector2 direction = button.target - button.position;
        double distance = direction.length;
        direction.normalize();
        button.position += direction * 200 * dt;

        // Stop moving once we're close enough to the target
        if (distance < 5) {
          button.position = button.target;
          button.isMoveable = false;
        }
      }
    }
    super.update(dt);
  }
}