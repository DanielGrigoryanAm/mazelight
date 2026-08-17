/// Per-level display and generation data for the level-select screen.
class LevelInfo {
  const LevelInfo({
    required this.number,
    required this.rows,
    required this.cols,
    required this.stars,
    required this.locked,
    this.isCurrent = false,
  });

  final int number;
  final int rows;
  final int cols;
  final int stars;
  final bool locked;
  final bool isCurrent;

  // Same seed = same maze for every player on a given level, per CLAUDE.md's
  // procedural-generation plan.
  int get seed => number;
}

const int levelCount = 20;

// The 20-level catalog. Board size grows with level number (see CLAUDE.md's
// difficulty progression: 7x7 through level 5, larger beyond). Level 1 is
// always unlocked; level N>1 unlocks once level N-1 has been completed
// (has stars in [starsByLevel], loaded from LevelProgressStore). "Current"
// (the green-glow highlight) is the first unlocked level not yet completed.
List<LevelInfo> buildLevels(Map<int, int> starsByLevel) {
  final levels = <LevelInfo>[];
  var currentAssigned = false;
  for (var number = 1; number <= levelCount; number++) {
    final stars = starsByLevel[number] ?? 0;
    final locked = number != 1 && (starsByLevel[number - 1] ?? 0) == 0;
    final isCurrent = !locked && stars == 0 && !currentAssigned;
    if (isCurrent) currentAssigned = true;
    levels.add(LevelInfo(
      number: number,
      rows: _sizeFor(number),
      cols: _sizeFor(number),
      stars: stars,
      locked: locked,
      isCurrent: isCurrent,
    ));
  }
  return levels;
}

// Board size + seed for [number], independent of unlock/star state — for
// screens (like MazeScreen jumping to "next level") that only need to
// generate that level's maze, not display its progress.
LevelInfo levelInfoFor(int number) => LevelInfo(
      number: number,
      rows: _sizeFor(number),
      cols: _sizeFor(number),
      stars: 0,
      locked: false,
    );

int _sizeFor(int level) {
  if (level <= 5) return 7;
  if (level <= 10) return 11;
  if (level <= 15) return 13;
  return 15;
}
