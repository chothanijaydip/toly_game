import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'component.dart';

class TolyGame extends FlameGame with KeyboardEvents {
  late final Adventurer player;
  late final Monster monster;
  final double step = 10;

  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    player = Adventurer();

    const String src = 'adventurer/animatronic.png';
    await images.load(src);
    var image = images.fromCache(src);
    SpriteSheet sheet = SpriteSheet.fromColumnsAndRows(image: image, columns: 13, rows: 6);
    Sprite sprite = sheet.getSpriteById(0);

    Vector2 monsterSize = Vector2(64,64);
    final double pY = _random.nextDouble()*size.y;
    final double pX = size.x;
    monster = Monster(sprite: sprite,size: monsterSize,position: Vector2(pX, pY));
    add(player);
    add(monster);
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;
    if (event.logicalKey == LogicalKeyboardKey.keyY && isKeyDown) {
      player.flip(y: true);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyX && isKeyDown) {
      player.flip(x: true);
    }

    if (event.logicalKey == LogicalKeyboardKey.keyJ && isKeyDown) {
      player.shoot();
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp
        || event.logicalKey == LogicalKeyboardKey.keyW
            && isKeyDown) {
      player.move(Vector2(0, -step));
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown
        || event.logicalKey == LogicalKeyboardKey.keyS
            && isKeyDown) {
      player.move(Vector2(0, step));

    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft
        || event.logicalKey == LogicalKeyboardKey.keyA
            && isKeyDown) {
      player.move(Vector2(-step, 0));
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight
        || event.logicalKey == LogicalKeyboardKey.keyD
            && isKeyDown) {
      player.move(Vector2(step, 0));
    }
    return super.onKeyEvent(event, keysPressed);
  }

}
