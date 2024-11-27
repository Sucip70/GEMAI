import 'dart:ui';

import 'package:flame/components.dart';

class TappableSpriteComponent extends SpriteComponent {
  late double initialScaleX;
  late double initialScaleY;
  final VoidCallback onPressed;
  bool isPressed = false;
  bool isDraggable = false;
  double scaleButton = 0.95;

  TappableSpriteComponent({
    required Sprite sprite,
    required this.onPressed,
    this.scaleButton = 0.95
  }) : super(size: sprite.srcSize) {
    this.sprite = sprite;
    initialScaleX = scale.x;
    initialScaleY = scale.y;
  }

  void onTapDown() {
    scale = Vector2(initialScaleX * scaleButton, initialScaleY * scaleButton);
  }

  void onTapUp() {
    scale = Vector2(initialScaleX, initialScaleY);
    onPressed();
  }

  void onTapCancel() {
    scale = Vector2(initialScaleX, initialScaleY);
  }
}