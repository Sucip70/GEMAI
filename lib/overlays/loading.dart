import 'package:flutter/cupertino.dart';
import 'package:gemai/comgen/assets.dart';
import 'package:gemai/screens/router.dart';

class LoadingOverlay extends StatefulWidget {
  final RouterGame game;

  LoadingOverlay({required this.game});

  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: widget.game.canvasSize.x,
          height: widget.game.canvasSize.y,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/BG1.png"))
          ),
          child: const Center(
            child: Text("Loading ...", style: TextStyle(fontFamily: Assets.fontPrimary, fontSize: 16, color: Color(0xFFCFAF8B)),),
          ),
        ),
      ),
    );
  }
}
