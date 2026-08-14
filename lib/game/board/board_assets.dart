import 'package:flame/sprite.dart';

/// Loads the maze's stone floor/wall textures from assets/images once at
/// startup. [Sprite.load] resolves against Flame's default image prefix,
/// which already matches this project's assets/images/ folder.
class BoardAssets {
  BoardAssets._({required this.floor, required this.bricks});

  final Sprite floor;
  final List<Sprite> bricks;

  static Future<BoardAssets> load() async {
    final floor = await Sprite.load('floor.png');
    final bricks = await Future.wait([
      Sprite.load('brick_1.png'),
      Sprite.load('brick_2.png'),
      Sprite.load('brick_3.png'),
      Sprite.load('brick_4.png'),
    ]);
    return BoardAssets._(floor: floor, bricks: bricks);
  }
}
