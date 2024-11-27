import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

class DraggableSpriteComponent extends SpriteComponent {
  late double initialScaleX;
  late double initialScaleY;
  final VoidCallback onPressed;
  bool isPressed = false;
  bool isDraggable = true;
  bool isLock = false;
  bool isMoveable = true;
  Vector2 target = Vector2.zero();
  Vector2 index;

  DraggableSpriteComponent({
    required Sprite sprite,
    required this.onPressed,
    required this.index
  }) : super(size: sprite.srcSize) {
    this.sprite = sprite;
    initialScaleX = scale.x;
    initialScaleY = scale.y;
  }

  void onDragUpdate(DragUpdateEvent info) {
    if(!isLock){
      position += info.deviceDelta;
    }
  }
}