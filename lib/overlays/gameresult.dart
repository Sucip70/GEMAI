import 'package:flame/game.dart' as g;
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/screens/router.dart';
import 'package:gemai/screens/map.dart';

class GameOverlay extends StatefulWidget {
  final RouterGame game;
  final GestureTapCallback? onTap;

  GameOverlay({required this.game, this.onTap});

  @override
  _GameOverlayState createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          FlameAudio.play(Assets.fxClick);
          widget.game.function();
          widget.game.overlays.remove('result');
          widget.game.router.pushReplacement(g.Route(MapPage.new));
        },
        child: Container(
          width: widget.game.canvasSize.x,
          height: widget.game.canvasSize.y,
          color: const Color.fromARGB(159, 0, 0, 0),
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: widget.game.canvasSize.x / 4,
                  height: widget.game.canvasSize.y,
                  child: Image.asset(
                    "assets/images/${widget.game.score != 0 ? (widget.game.chara == 'GHEA' ? Assets.charaGhea : Assets.charaKala ) : (widget.game.chara == 'GHEA' ? Assets.charaGheaSad : Assets.charaKalaSad )}",
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  width: 300,
                  height: 150,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 226, 215, 206),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      Text("${widget.game.statusGame}!!",style: TextStyle(
                          fontFamily: Assets.fontPrimary,
                          color:widget.game.statusGame=="MENANG"?const Color.fromARGB(255, 109, 137, 19):const Color.fromARGB(255, 137, 19, 35), //Color.fromARGB(255, 109, 137, 19),
                          fontSize: 34,
                        ),),
                      Expanded(child: 
                        Text("skor : ${widget.game.score}",style: const TextStyle(
                            fontFamily: Assets.fontPrimary,
                            color: Color.fromARGB(161, 74, 74, 74),
                            fontSize: 28,
                          ),),
                      ),
                      const Text("Tekan dimana saja untuk melanjutkan",style: TextStyle(
                          fontFamily: Assets.fontPrimary,
                          color: Color.fromARGB(255, 160, 160, 160),
                          fontSize: 12,
                        ),),
                    ],
                  ),
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}
