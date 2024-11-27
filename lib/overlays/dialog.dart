import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/screens/router.dart';

class DialogOverlay extends StatefulWidget {
  final RouterGame game;
  final GestureTapCallback? onTap;

  DialogOverlay({required this.game, this.onTap});

  @override
  _DialogOverlayState createState() => _DialogOverlayState();
}

class _DialogOverlayState extends State<DialogOverlay> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          FlameAudio.play(Assets.fxClick);
          setState(() {
            index++;
            if (index >= widget.game.dialog.length) {
              index = 0;
              widget.game.function();
              widget.game.overlays.remove('dialog');
            }
          });
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
                  width: widget.game.canvasSize.x / 3,
                  height: widget.game.canvasSize.y,
                  child: Image.asset(
                    "assets/images/${widget.game.chara == 'GHEA' ? Assets.charaGhea : Assets.charaKala}",
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  width: widget.game.canvasSize.x - 100,
                  height: 80,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 215, 206),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.game.dialog[index],
                    style: const TextStyle(
                      fontFamily: Assets.fontPrimary,
                      color: Color.fromARGB(255, 46, 46, 46),
                      fontSize: 21,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
