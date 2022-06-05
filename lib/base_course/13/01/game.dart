import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/circle.dart';
import 'components/line.dart';

class TolyGame extends FlameGame with PanDetector{

  late Line line;
  late Circle circle;
  @override
  Future<void> onLoad()async{
    circle = Circle(radius: 40,position: size/2);
    line = Line(lineWidth: 80,position: size/2-Vector2(140,0));
    add(circle);
    add(line);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    line.position+=info.delta.global;
  }
}