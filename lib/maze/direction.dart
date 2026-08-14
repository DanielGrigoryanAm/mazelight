enum Direction {
  north,
  east,
  south,
  west;

  Direction get opposite => switch (this) {
        Direction.north => Direction.south,
        Direction.east => Direction.west,
        Direction.south => Direction.north,
        Direction.west => Direction.east,
      };

  int get dRow => switch (this) {
        Direction.north => -1,
        Direction.south => 1,
        Direction.east => 0,
        Direction.west => 0,
      };

  int get dCol => switch (this) {
        Direction.east => 1,
        Direction.west => -1,
        Direction.north => 0,
        Direction.south => 0,
      };
}
