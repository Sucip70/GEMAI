import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

class DraggableSpriteAnimComponent extends SpriteAnimationComponent {
  late double initialScaleX;
  late double initialScaleY;
  final VoidCallback onPressed;
  bool isPressed = false;
  bool isDraggable = true;
  bool isLock = false;
  bool isMoveable = true;
  Vector2 target = Vector2.zero();
  Vector2 index;

  DraggableSpriteAnimComponent({
    required SpriteAnimation animation,
    required this.onPressed,
    required this.index
  }) : super() {
    this.animation = animation;
    initialScaleX = scale.x;
    initialScaleY = scale.y;
  }

  void onDragUpdate(DragUpdateEvent info) {
    if(!isLock){
      position += info.deviceDelta;
    }
  }
}