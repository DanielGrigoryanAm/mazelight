import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../maze/direction.dart';
import '../maze/grid_position.dart';
import '../maze/maze.dart';
import 'board/board_assets.dart';
import 'board/board_theme.dart';
import 'board/floor_backdrop_component.dart';
import 'board/maze_board_component.dart';
import 'exit/exit_marker_component.dart';
import 'player/player_component.dart';

class MazeGame extends FlameGame {
  MazeGame({required this.maze});

  final Maze maze;
  MazeBoardComponent? _board;
  PlayerComponent? _player;

  @override
  Color backgroundColor() => BoardTheme.background;

  @override
  Future<void> onLoad() async {
    final assets = await BoardAssets.load();

    await camera.backdrop.add(FloorBackdropComponent(floor: assets.floor));

    final board = MazeBoardComponent(maze: maze, assets: assets);
    _board = board;
    await world.add(board);

    await world.add(ExitMarkerComponent(gridPosition: maze.exit));

    final player = PlayerComponent(gridPosition: maze.entrance);
    _player = player;
    await world.add(player);

    camera.viewfinder.position = board.size / 2;
    camera.viewfinder.anchor = Anchor.center;
    _fitViewport();
  }

  // Ball rolls slower the less the joystick is pushed: barely past the dead
  // zone still moves at [_minSpeedFactor] rather than crawling to a halt.
  static const double _minSpeedFactor = 0.35;

  // Called by the joystick; ignored while the player is still gliding to
  // its previous target so rapid repeat-steps can't stack up mid-animation.
  void movePlayer(Direction direction, double intensity) {
    final player = _player;
    if (player == null || player.isMoving) return;

    final current = player.gridPosition;
    if (!maze.canMove(current, direction)) return;

    final speedFactor =
        _minSpeedFactor + (1 - _minSpeedFactor) * intensity.clamp(0.0, 1.0);
    player.moveTo(
      GridPosition(current.row + direction.dRow, current.col + direction.dCol),
      speedFactor: speedFactor,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _fitViewport();
  }

  // Fit (not cover) the maze so it's always fully visible, never cropped —
  // any leftover margin is filled by the floor backdrop instead of zooming
  // the maze itself up to cover the screen.
  void _fitViewport() {
    final board = _board;
    if (board == null) return;
    final zoomX = size.x / board.size.x;
    final zoomY = size.y / board.size.y;
    camera.viewfinder.zoom = zoomX < zoomY ? zoomX : zoomY;
  }
}
