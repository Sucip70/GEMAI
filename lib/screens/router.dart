import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/game/catch.dart';
import 'package:gemai/game/exam.dart';
import 'package:gemai/game/hide_and_seek.dart';
import 'package:gemai/game/puzzle.dart';
import 'package:gemai/game/satan.dart';
import 'package:gemai/screens/chara_pick.dart';
import 'package:gemai/screens/home.dart';
import 'package:gemai/screens/board.dart';
import 'package:gemai/screens/knowledge.dart';
import 'package:gemai/screens/map.dart';
import 'package:gemai/screens/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterGame extends FlameGame{
  late final RouterComponent router;
  String chara = "";
  List<String> dialog = [];
  Route nextGame = Route(Home.new);
  String nextRoute = "";
  String book = "";
  int indexQuestion = 0;
  String statusGame = "";
  int score = 0;
  void Function() function =() {};
  AudioPlayer? player;
  AudioPlayer? mainPlayer;
  late Image charaGheaImage;
  late SpriteAnimation gheaAnim;
  late Image charaKalaImage;
  late SpriteAnimation kalaAnim;
  late Image bookInjilImage;
  late Image bookTauratImage;
  late Image dripImage;
  late Image satan1Image;
  late Image satan11Image;
  late Image satan2Image;
  late Image boardImage;
  late Image buttonImage;
  late Image bubbleImage;
  late Image bulletImage;
  late Image charaTeacherImage;
  late Image titleImage;
  late Image title;
  late Image startButtonImage;
  late Image nextButtonImage;
  late Image prevButtonImage;
  late Image mapImage;
  late Image loc1Image;
  late Image loc2Image;
  late Image loc3Image;
  late Image loc4Image;
  late Image loc5Image;
  late Image buttonHomeImage;
  late SharedPreferences prefs;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'home': Route(Home.new),
          'chara': Route(CharaPick.new),
          'board': Route(Board.new),
          'map': Route(MapPage.new),
          'knowledge': Route(Knowledge.new),
          'question': Route(Question.new),
          'game1': Route(HideAndSeek.new),
          'game2': Route(Puzzle.new),
          'game3': Route(Catch.new),
          'game4': Route(Satan.new),
          'exam': Route(Exam.new),
        },
        initialRoute: 'home',
      ),
    );

    await FlameAudio.audioCache.load(Assets.bgm1);
    await FlameAudio.audioCache.load(Assets.bgm2);
    await FlameAudio.audioCache.load(Assets.bgm3);
    await FlameAudio.audioCache.load(Assets.bgm4);
    await FlameAudio.audioCache.load(Assets.bgm5);
    await FlameAudio.audioCache.load(Assets.fxClick);
    await FlameAudio.audioCache.load(Assets.fxLose);
    await FlameAudio.audioCache.load(Assets.fxCorrect);
    await FlameAudio.audioCache.load(Assets.fxShot);
    await FlameAudio.audioCache.load(Assets.fxShow);
    await FlameAudio.audioCache.load(Assets.fxWin);
    await FlameAudio.audioCache.load(Assets.fxWrong);
    await FlameAudio.audioCache.load(Assets.fxGemai);
    await FlameAudio.audioCache.load(Assets.fxPilih);

    charaGheaImage = await Flame.images.load(Assets.charaGhea);
    List<Sprite> gheaSprites = [];
    List<double> gheaStepTimes = [];
    for(var i=0; i<Assets.animGhea.length; i++){
      gheaSprites.add(
        Sprite(await Flame.images.load(Assets.animGhea[i]["image"] as String))
      );
      gheaStepTimes.add(Assets.animGhea[i]["time"] as double);
    }
    gheaAnim = SpriteAnimation.variableSpriteList(gheaSprites, stepTimes: gheaStepTimes);
    
    charaKalaImage = await Flame.images.load(Assets.charaKala);
    List<Sprite> kalaSprites = [];
    List<double> kalaStepTimes = [];
    for(var i=0; i<Assets.animKala.length; i++){
      kalaSprites.add(
        Sprite(await Flame.images.load(Assets.animKala[i]["image"] as String))
      );
      kalaStepTimes.add(Assets.animKala[i]["time"] as double);
    }
    kalaAnim = SpriteAnimation.variableSpriteList(kalaSprites, stepTimes: kalaStepTimes);
    
    bookTauratImage = await Flame.images.load(Assets.item1);
    bookInjilImage = await Flame.images.load(Assets.item5);
    dripImage = await Flame.images.load(Assets.item6);
    bulletImage = await Flame.images.load(Assets.item7);
    bubbleImage = await Flame.images.load(Assets.item8);
    boardImage = await Flame.images.load(Assets.block1);
    titleImage = await Flame.images.load(Assets.block2);
    buttonImage = await Flame.images.load(Assets.block3);
    satan1Image = await Flame.images.load(Assets.charaSetan1);
    satan11Image = await Flame.images.load(Assets.charaSetan11);
    satan2Image = await Flame.images.load(Assets.charaSetan2);
    charaTeacherImage = await Flame.images.load(Assets.charaTeacher);
    title = await Flame.images.load(Assets.title);
    startButtonImage = await Flame.images.load(Assets.btnStart);
    nextButtonImage = await Flame.images.load(Assets.btnNext);
    prevButtonImage = await Flame.images.load(Assets.btnBack);
    mapImage = await Flame.images.load(Assets.map);
    loc1Image = await Flame.images.load(Assets.item2);
    loc2Image = await Flame.images.load(Assets.item3);
    loc3Image = await Flame.images.load(Assets.item4);
    loc4Image = await Flame.images.load(Assets.item9);
    loc5Image = await Flame.images.load(Assets.item10);
    buttonHomeImage = await Flame.images.load(Assets.item12);

    for(var i=0; i<6; i++){
      for(var j=0; j<4; j++){
        await Flame.images.load("puzzle${i+1}${j+1}.png");
      }
    }

    for(var i=1; i<=8; i++){
      await Flame.images.load("BG$i.png");
    }
    await Flame.images.load("Item11.png");

    prefs = await SharedPreferences.getInstance();
  }

  void playSound(String audio) async {
    player = await FlameAudio.loopLongAudio(audio,volume: 0.7);
  }

  void stopSound() {
    player?.stop();
    player = null; 
  }

  void pauseMainSound(){
    player?.pause();
  }

  void resumeMainSound(){
    player?.resume();
  }

  void playMainSound() async{
    player = await FlameAudio.loopLongAudio(Assets.bgm6, volume: 0.5);
  }

  List<int> getRandomIndices(int maxLength, int count) {
    Random random = Random();
    Set<int> indices = {};
    while (indices.length < count) {
      indices.add(random.nextInt(maxLength));
    }
    return indices.toList();
  }

  @override
  void onRemove() {
    removeAll(children);
    processLifecycleEvents();
    Flame.images.clearCache();
    Flame.assets.clearCache();
    FlameAudio.bgm.audioPlayer.audioCache.clearAll();
    FlameAudio.audioCache.clearAll();
  }

  @override void lifecycleStateChange(AppLifecycleState state) {
    if(state.name=="inactive"){
      pauseMainSound();
    }else if(state.name=="resumed"){
      resumeMainSound();
    }
    super.lifecycleStateChange(state);
  }

  Future<void> save(String key, String value) async {
    await prefs.setString(key, value);
  }

  String get(String key) {
    return prefs.getString(key) ?? ""; // Default to 0 if no score is saved
  }
}