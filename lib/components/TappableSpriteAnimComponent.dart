import 'dart:ui';

import 'package:flame/components.dart';

class TappableSpriteAnimComponent extends SpriteAnimationComponent {
  late double initialScaleX;
  late double initialScaleY;
  final VoidCallback onPressed;
  bool isPressed = false;
  bool isDraggable = false;
  double scaleButton = 0.95;

  TappableSpriteAnimComponent({
    required SpriteAnimation animation,
    required this.onPressed,
    this.scaleButton = 0.95
  }) {
    this.animation = animation;
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