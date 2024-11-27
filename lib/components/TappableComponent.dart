import 'dart:ui';
import 'package:flame/components.dart';

class TappableComponent extends PositionComponent {
  late double initialScaleX;
  late double initialScaleY;
  final VoidCallback onPressed;
  bool isPressed = false;
  double scaleButton = 0.95;

  TappableComponent({
    required PositionComponent component,
    required this.onPressed,
    this.scaleButton = 0.95
  }) : super(position: component.position, size: component.size, anchor: component.anchor) {
    initialScaleX = scale.x;
    initialScaleY = scale.y;
    children.addAll(component.children); 
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