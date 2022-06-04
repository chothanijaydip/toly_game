import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'adventurer.dart';
import 'bullet.dart';
import 'life.dart';

class HeroAttr {
  double life; // 生命值
  double speed; // 速度
  double attackSpeed; // 攻击速度
  double attackRange; // 射程
  double attack; // 攻击力
  double crit; // 暴击率
  double critDamage; // 暴击伤害

  HeroAttr({
    required this.life,
    required this.speed,
    required this.attackSpeed,
    required this.attackRange,
    required this.attack,
    required this.crit,
    required this.critDamage,
  });
}

class HeroComponent extends PositionComponent with HasGameRef {
  HeroAttr attr;
  late Adventurer adventurer;
  late LifeComponent lifeComponent;
  bool isLeft = true;

  late Sprite bulletSprite;
  final SpriteAnimation spriteAnimation;

  HeroComponent({
    required initPosition,
    required this.attr,
    required this.spriteAnimation,
    required Vector2 size,
  }) : super(
          size: size,
          anchor: Anchor.center,
    position: initPosition
        );

  @override
  Future<void> onLoad() async {
    adventurer = Adventurer(
        size: size, spriteAnimation: spriteAnimation, onLastFrame: addBullet);
    adventurer.position = adventurer.size / 2;
    lifeComponent = LifeComponent(
        lifePoint: attr.life,
        lifeColor: Colors.blue,
        position: adventurer.position,
        size: adventurer.size);
    bulletSprite = await gameRef.loadSprite('adventurer/weapon_arrow.png');
    add(adventurer);
    add(lifeComponent);
  }

  // 添加子弹
  void addBullet() {
    Bullet bullet = Bullet(
      sprite: bulletSprite,
      maxRange: attr.attackRange,
      speed: attr.attackSpeed,
      isLeft: isLeft,
    );
    bullet.size = Vector2(32, 32);
    bullet.anchor = Anchor.center;
    bullet.priority = 1;
    priority = 2;
    bullet.position = position - Vector2(0, -3);
    gameRef.add(bullet);
  }

  void flip({
    bool x = false,
    bool y = true,
  }) {
    adventurer.flip(x: x, y: y);
    isLeft = !isLeft;
  }

  void shoot() {
    adventurer.shoot();
  }

  void move(Vector2 ds) {
    position.add(ds);
  }

  void rotateTo(double deg) {
    adventurer.angle = deg;
  }

  void _checkFlip(Vector2 target) {
    if (target.x < position.x) {
      if (isLeft) {
        flip();
      }
    }
    if (target.x > position.x) {
      if (!isLeft) {
        flip();
      }
    }
  }

  void toTarget(Vector2 target) {
    _checkFlip(target);
    removeAll(children.whereType<MoveEffect>());
    double timeMs = (target - position).length / attr.speed;
    add(
      MoveEffect.to(
        target,
        EffectController(
          duration: timeMs,
        ),
      ),
    );
  }
}
