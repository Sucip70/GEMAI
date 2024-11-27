import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gemai/screens/router.dart';

class Background extends SpriteComponent with HasGameRef<RouterGame>{
  final String assetPath;

  Background({required this.assetPath});

  @override
  void onLoad() {
    final bg = Flame.images.fromCache(assetPath);
    size = gameRef.size;
    sprite = Sprite(bg);
  }
}